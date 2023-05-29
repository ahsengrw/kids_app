import 'dart:async';
import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bounce_button/bounce_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gif/gif.dart';
import 'package:kids_app/SharedContent/constants.dart';
import 'package:kids_app/State%20Management/play_stop_bg_music.dart';
import 'package:kids_app/extra.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with TickerProviderStateMixin {
  late CameraController cameraController;

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );
    cameraController = CameraController(
      frontCamera,
      ResolutionPreset.high,
    );
    await cameraController.initialize();
    setState(() {
      cameraLoading = false;
    });
  }

  bool _assetsLoaded = true;
  bool cameraLoading = true;

  List<String> gifAssetsHearing = [
    'assets/animals_hearing/cat.gif',
    'assets/animals_hearing/bird.gif',
    'assets/animals_hearing/cow.gif',
    'assets/animals_hearing/dog.gif',
    'assets/animals_hearing/duck.gif',
    'assets/animals_hearing/giraffe.gif',
    'assets/animals_hearing/hen.gif',
    'assets/animals_hearing/monkey.gif',
    'assets/animals_hearing/zebra.gif',
  ];

  List<String> bgs = [
    'assets/Background Images/1.png',
    'assets/Background Images/2.png',
    'assets/Background Images/3.png',
    'assets/Background Images/4.png',
    'assets/Background Images/5.png',
    'assets/Background Images/6.png',
    'assets/Background Images/7.png',
    'assets/Background Images/8.png',
    'assets/Background Images/9.png',
  ];

  List<String> gifAssetsTalking = [
    'assets/animals_talking/cat.gif',
    'assets/animals_talking/bird.gif',
    'assets/animals_talking/cow.gif',
    'assets/animals_talking/dog.gif',
    'assets/animals_talking/duck.gif',
    'assets/animals_talking/giraffe.gif',
    'assets/animals_talking/hen.gif',
    'assets/animals_talking/monkey.gif',
    'assets/animals_talking/zebra.gif',
  ];

  List<String> dancingGifs = [
    'assets/Animals Dances/Cat.gif',
    'assets/Animals Dances/bird.gif',
    'assets/Animals Dances/cow.gif',
    'assets/Animals Dances/dog.gif',
    'assets/Animals Dances/duck.gif',
    'assets/Animals Dances/giraffe.gif',
    'assets/Animals Dances/hen.gif',
    'assets/Animals Dances/monkey.gif',
    'assets/Animals Dances/zebra.gif',
  ];

  List<String> animalsVoices = [
    "assets/dance.mp3",
    "assets/dance.mp3",
    "assets/dance.mp3",
    "assets/dance.mp3",
    "assets/dance.mp3",
    "assets/dance.mp3",
    "assets/dance.mp3",
    "assets/dance.mp3",
    "assets/dance.mp3",
  ];

  List<String> imagesList = [
    'assets/animals_icons/Cat.png',
    'assets/animals_icons/Bird.png',
    'assets/animals_icons/Cow.png',
    'assets/animals_icons/Dog.png',
    'assets/animals_icons/Duck.png',
    'assets/animals_icons/Giraffe.png',
    'assets/animals_icons/Hen.png',
    'assets/animals_icons/Monkey.png',
    'assets/animals_icons/Zebra.png',
  ];

  String? selectedAsset;

  String backgroundAsset = 'assets/Background Images/1.png';

  // int _fps = 22;

  Future<void> precacheAudioAssets(List<String> assetUrls) async {
    for (var url in assetUrls) {
      await DefaultCacheManager().downloadFile(url);
    }
  }

  @override
  void initState() {
    Provider.of<AudioModel>(context, listen: false).stopAudio();
    precacheAudioAssets(imagesList);
    precacheAudioAssets(animalsVoices);
    precacheAudioAssets(dancingGifs);
    precacheAudioAssets(gifAssetsTalking);
    precacheAudioAssets(bgs);
    precacheAudioAssets(gifAssetsHearing);
    initCamera();
    initRecorder();
    setState(() {
      _assetsLoaded = false;
    });
    super.initState();
  }

  Timer? activeTimer;

  File? pathToAudio;
  int? seconds;

  @override
  void dispose() {
    stopSound();
    cameraController.dispose();
    recorder.closeAudioSession();
    super.dispose();
  }

  bool showProgress = false;

  bool isExpanded = false;

  bool isRecorderReady = false;

  final recorder = FlutterSoundRecorder();

  int? selectedIndex;

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      showToast(context, 'Permission not granted');
    }

    await recorder.openAudioSession();

    isRecorderReady = true;

    recorder.setSubscriptionDuration(Duration(milliseconds: 500));
  }

  List whichIsActive = List.filled(9, false);

  // Declare a variable to keep track of the current running loop
  int? currentLoopIndex;

// Function to cancel the current loop
  void cancelLoop() {
    currentLoopIndex = null;
    whileTrue = false;
  }

  Future record() async {
    // if (!whileTrue) return;
    print('recording start....................');
    if (!isRecorderReady) return;
    await recorder.startRecorder(
      toFile: 'audio',
      bitRate: 128000,
      sampleRate: 44100,
    );
  }

  Future stop() async {
    // if (!whileTrue) return;
    print('recording stopped...................');
    if (!isRecorderReady) return;
    final path = await recorder.stopRecorder();
    File audioPath = File(path!);
    pathToAudio = audioPath;
    print('Recorded Audio : ${audioPath}');
  }

  bool _buttonEnabled = true;

  String? selectedVoice;

  final assetAudioPlayer = AssetsAudioPlayer();

  void playSound(String path) {
    print('sound played of asset...................');
    assetAudioPlayer.open(Audio(path));
  }

  void playSoundFile(String path) {
    if (!whileTrue) return;
    print('sound played of recording...................');
    assetAudioPlayer.open(Audio.file(path));
  }

  void stopSound() {
    print('sound stopped...................');
    assetAudioPlayer.stop();
  }

  final spinkit = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: redishOrange,
        ),
      );
    },
  );

  bool whileTrue = true;
  bool isSessionCleared = true;

  Timer? recordingTimer;

  int enabledIndex = 0;

  @override
  Widget build(BuildContext context) {
    return _assetsLoaded
        ? Scaffold(
            body: Center(
              child: spinkit,
            ),
          )
        : cameraLoading
            ? Scaffold(
                body: Center(
                  child: spinkit,
                ),
              )
            : Scaffold(
                body: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      colorFilter:
                          ColorFilter.mode(lightBlue, BlendMode.lighten),
                      image: AssetImage(
                        'assets/greenBg.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 6,
                        child: isExpanded
                            ? Container(
                                width: double.infinity,
                                child: AspectRatio(
                                  aspectRatio:
                                      cameraController.value.aspectRatio,
                                  child: CameraPreview(cameraController),
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image: AssetImage(backgroundAsset),
                                  fit: BoxFit.cover,
                                )),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      child: selectedAsset == null
                                          ? SizedBox()
                                          : Image.asset(
                                              selectedAsset!,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.3,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                            ),
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                    ),
                                    Positioned(
                                      child:
                                          // selectedIndex == null
                                          //     ? SizedBox()
                                          //     :

                                          InkWell(
                                        onTap: () async {
                                          if (recordingTimer != null) {
                                            recordingTimer!.cancel();
                                            print('recorder timer $recordingTimer');
                                          }
                                          setState(() {
                                            selectedAsset =
                                                dancingGifs[selectedIndex!];
                                            selectedVoice =
                                                animalsVoices[selectedIndex!];
                                          });
                                          stopSound();
                                          await stop();
                                          playSound(selectedVoice!);
                                        },
                                        child: selectedAsset == null
                                            ? SizedBox()
                                            : Image.asset(
                                                'assets/speaker.png',
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.14,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.14,
                                              ),
                                      ),
                                      bottom:
                                          MediaQuery.of(context).size.width *
                                              0.1,
                                      right: MediaQuery.of(context).size.width *
                                          0.15,
                                    ),
                                    Positioned(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          // borderRadius: BorderRadius.circular(15),
                                          border: Border(
                                            left: BorderSide(
                                              color: Colors.red,
                                              width: 5.0,
                                            ),
                                            bottom: BorderSide(
                                              color: Colors.blue,
                                              width: 5.0,
                                            ),
                                          ),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                        child: AspectRatio(
                                          aspectRatio: cameraController
                                              .value.aspectRatio,
                                          child:
                                              CameraPreview(cameraController),
                                        ),
                                      ),
                                      top: 0,
                                      right: 0,
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Stack(children: [
                          Padding(
                            padding: const EdgeInsets.all(21),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: GridView.builder(
                                itemCount: imagesList.length,
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisExtent:
                                      MediaQuery.of(context).size.height * 0.1,
                                  mainAxisSpacing: 7,
                                  // crossAxisSpacing: 12,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  // Create the button widget
                                  return Bounce(
                                    // Updated onTap function
                                    onTap: () async {
                                      if (_buttonEnabled) {

                                        if (recordingTimer != null) {
                                          recordingTimer!.cancel();
                                          print('recorder timer $recordingTimer');
                                        }

                                        setState(() {
                                          _buttonEnabled = false;
                                          // whileTrue = true;
                                          selectedAsset =
                                              gifAssetsHearing[index];
                                          backgroundAsset = bgs[index];
                                          selectedIndex = index;
                                        });
                                        await stop();
                                        stopSound();
                                        recordingTimer = Timer.periodic(
                                            Duration(milliseconds: 250),
                                            (timer) async {
                                          if (isSessionCleared == true) {
                                            isSessionCleared = false;
                                            // await stop();
                                            // stopSound();
                                            setState(() {
                                              selectedAsset = gifAssetsHearing[
                                                  selectedIndex!];
                                            });
                                            await record();
                                            await Future.delayed(
                                                Duration(seconds: 5));
                                            await stop();
                                            setState(() {
                                              _buttonEnabled = true;
                                              selectedAsset = gifAssetsTalking[
                                                  selectedIndex!];
                                            });
                                            playSoundFile(pathToAudio!.path);
                                            await Future.delayed(
                                                Duration(seconds: 5));
                                            isSessionCleared = true;
                                          }
                                        });
                                        // while (whileTrue) {
                                        //   if(enabledIndex != index){
                                        //     break;
                                        //   }
                                        //   await stop();
                                        //   stopSound();
                                        //   setState(() {
                                        //     selectedAsset = gifAssetsHearing[
                                        //     selectedIndex!];
                                        //   });
                                        //   await record();
                                        //   await Future.delayed(
                                        //       Duration(seconds: 5));
                                        //   await stop();
                                        //   setState(() {
                                        //     _buttonEnabled = true;
                                        //     selectedAsset = gifAssetsTalking[
                                        //     selectedIndex!];
                                        //   });
                                        //   playSoundFile(pathToAudio!.path);
                                        //   await   Future.delayed(Duration(seconds: 5));
                                        // }
                                        enabledIndex = index;
                                        print('enable index $enabledIndex');
                                      } else {
                                        showToast(context, 'button disabled');
                                      }
                                    },

                                    duration: Duration(milliseconds: 300),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              spreadRadius: 3,
                                              blurRadius: 15,
                                              offset: Offset(0, 3),
                                            ),
                                          ]),
                                      child: Center(
                                        child: Image.asset(
                                          imagesList[index],
                                          width: 40,
                                          height: 40,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  isExpanded = !isExpanded;
                                  stop();
                                  stopSound();
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: yellowish,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 22.0,
                                    vertical: 5,
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 25,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              );
  }
}
