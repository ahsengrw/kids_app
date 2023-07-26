import 'dart:async';
import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bounce_button/widget/bounce_click.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../SharedContent/constants.dart';
import '../State Management/camera_provider.dart';
import '../State Management/play_stop_bg_music.dart';

class OpenCamera extends StatefulWidget {
  @override
  _OpenCameraState createState() => _OpenCameraState();
}

class _OpenCameraState extends State<OpenCamera> with TickerProviderStateMixin {
  void _requestCameraPermission() async {
    PermissionStatus cameraStatus = await Permission.camera.request();
    PermissionStatus microphoneStatus = await Permission.microphone.request();

    if (cameraStatus.isGranted && microphoneStatus.isGranted) {
      print('permission is granted ........... ${microphoneStatus}');
      print('permission is granted ........... ${cameraStatus}');
      // Permissions granted for both camera and microphone
      // Do something, like opening the camera
    } else if (cameraStatus.isDenied || microphoneStatus.isDenied) {
      print('permission is denied ........... ${microphoneStatus}');
      print('permission is denied ........... ${cameraStatus}');
      // Permission denied for either camera or microphone
      // Show a dialog to the user explaining why you need the permission
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Permissions Required'),
          content: Text(
              'Please grant camera and microphone permissions to proceed.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Open Settings'),
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
            ),
          ],
        ),
      );
    } else if (cameraStatus.isPermanentlyDenied ||
        microphoneStatus.isPermanentlyDenied) {
      // Permissions permanently denied for either camera or microphone
      // Show an alert dialog or navigate to the app settings
      // openAppSettings();
    }

    if (cameraStatus.isGranted && microphoneStatus.isGranted) {
      // Permissions granted for both camera and microphone
      // Do additional logic here if needed
      // For example, you can start the camera initialization process
      final cameraProvider =
          Provider.of<CameraProvider>(context, listen: false);
      await cameraProvider.initCamera();
      await initRecorder();
    }
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
    // 'assets/animals_hearing/hen.gif',
    'assets/animals_hearing/monkey.gif',
    'assets/animals_hearing/zebra.gif',
    // '',
    'assets/animals_hearing/elephant.gif',
    // '',
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
    // 'assets/Background Images/5.png',
    // 'assets/Background Images/5.png',
    // 'assets/Background Images/5.png',
  ];

  List<String> gifAssetsTalking = [
    'assets/animals_talking/cat.gif',
    'assets/animals_talking/bird.gif',
    'assets/animals_talking/cow.gif',
    'assets/animals_talking/dog.gif',
    'assets/animals_talking/duck.gif',
    'assets/animals_talking/giraffe.gif',
    // 'assets/animals_talking/hen.gif',
    'assets/animals_talking/monkey.gif',
    'assets/animals_talking/zebra.gif',
    // '',
    'assets/animals_talking/elephant.gif',
    // '',
  ];

  List<String> dancingGifs = [
    'assets/Animals Dances/cat.gif',
    'assets/Animals Dances/bird.gif',
    'assets/Animals Dances/cow.gif',
    'assets/Animals Dances/dog.gif',
    'assets/Animals Dances/duck.gif',
    'assets/Animals Dances/giraffe.gif',
    // 'assets/Animals Dances/hen.gif',
    'assets/Animals Dances/monkey.gif',
    'assets/Animals Dances/zebra.gif',
    // '',
    'assets/Animals Dances/elephant.gif',
    // '',
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
    // "assets/dance.mp3",
    // "assets/dance.mp3",
    // "assets/dance.mp3",
  ];

  List<String> imagesList = [
    'assets/animals_icons/Cat.png',
    'assets/animals_icons/Bird.png',
    'assets/animals_icons/Cow.png',
    'assets/animals_icons/Dog.png',
    'assets/animals_icons/Duck.png',
    'assets/animals_icons/Giraffe.png',
    // 'assets/animals_icons/Hen.png',
    'assets/animals_icons/Monkey.png',
    'assets/animals_icons/Zebra.png',
    // '',
    'assets/animals_icons/Elephant.png',
    // '',
  ];

  String? selectedAsset;

  String backgroundAsset = 'assets/Background Images/1.png';

  // int _fps = 22;

  Future<void> precacheAudioAssets(List<String> assetUrls) async {
    for (var url in assetUrls) {
      await DefaultCacheManager().downloadFile(url);
    }
  }

  // late final GifController controller1;

  AnimationController? _animationController;
  Animation<Offset>? _slideAnimation;

  @override
  void initState() {
    // _initializeControllerFuture = _initializeCamera();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, // lock to portrait orientation
    ]);
    initializeScreen();
    audioModel = Provider.of<AudioModel>(context, listen: false);
    isMusicOn = audioModel!.isPlaying;
    audioModel!.stopAudio();
    super.initState();
  }

  AudioModel? audioModel;

  bool isMusicOn = true;

  initializeScreen() async {
    try {
      _requestCameraPermission();
      // // controller1 = GifController(vsync: this);
      precacheAudioAssets(imagesList);
      precacheAudioAssets(animalsVoices);
      precacheAudioAssets(dancingGifs);
      precacheAudioAssets(gifAssetsTalking);
      precacheAudioAssets(bgs);
      precacheAudioAssets(gifAssetsHearing);
      initRecorder();
      _animationController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 1),
      );
      _slideAnimation = Tween<Offset>(
        begin: Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController!,
        curve: Curves.fastEaseInToSlowEaseOut,
      ));
      _animationController!.forward();
      setState(() {
        _assetsLoaded = false;
      });
    } on Exception catch (e) {
      print('************************$e');
      // TODO
      setState(() {
        _assetsLoaded = false;
      });
    }
  }

  Timer? activeTimer;

  File? pathToAudio;
  int? seconds;

  AssetsAudioPlayer voicePlayer = AssetsAudioPlayer.newPlayer();

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();

    if (isMusicOn) {
      audioModel!.playAudio();
    }

    voicePlayer.dispose();

    assetAudioPlayerN.dispose();

    stopSound();
    stopSoundN();


    recorder.closeAudioSession();
    _animationController!.dispose();
    super.dispose();
  }

  bool showProgress = false;

  bool isExpanded = false;

  bool isRecorderReady = false;

  final recorder = FlutterSoundRecorder();

  int? selectedIndex;

  Future initRecorder() async {
    // final status = await Permission.microphone.request();
    // if (status != PermissionStatus.granted) {
    //   showToast(context, 'Permission not granted');
    // }

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
    pathToAudio = null;
    final path = await recorder.stopRecorder();
    File audioPath = File(path!);
    pathToAudio = audioPath;
    print('Recorded Audio : ${audioPath}');
  }

  bool _buttonEnabled = true;

  String? selectedVoice;

  final assetAudioPlayerN = AssetsAudioPlayer();

  void playSound(String path) {
    print('sound played of asset...................');
    assetAudioPlayerN.open(Audio(path));
  }

  Future<String> getLocalFilePath(String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$filename';
  }

  // void playSoundFile(String path) {
  //   if (!whileTrue) return;
  //   print('sound played of recording...................');
  //   try {
  //     assetAudioPlayerN.open(Audio.file(path));
  //   } on Exception catch (e) {
  //     // TODO
  //     print('Error $e');
  //     print('*************************************************************');
  //   }
  // }

  void playSoundFile(String path) async {
    if (!whileTrue) return;
    print('sound played of recording...................');
    try {
      String localPath = await getLocalFilePath('audio.mp3');
      await File(path).copy(localPath);
      assetAudioPlayerN.open(
        Audio.file(localPath),
        autoStart: true, // Ensure the audio starts playing immediately
        showNotification: false, // Hide the notification
      );
    } catch (e) {
      // Handle the error
      print('Error: $e');
      print('*************************************************************');
    }
  }

  final audioPlayer = FlutterSoundPlayer();

  void playSoundFileN(String path) async {
    if (!whileTrue) return;
    print('sound played of recording...................');
    try {
      // Open the audio file using flutter_sound
      await audioPlayer.openAudioSession();
      await audioPlayer.startPlayer(
        fromURI: path,
        codec: Codec.mp3,
        whenFinished: () {
          // Playback finished
        },
      );
    } catch (e) {
      // Handle the error
      print('Error: $e');
      print('*************************************************************');
    }
  }

  void stopSoundN() {
    print('sound stopped...................');
    audioPlayer.stopPlayer();
    audioPlayer.closeAudioSession();
  }



  void stopSound() {
    print('sound stopped...................');
    assetAudioPlayerN.stop();
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
  bool dancing = false;
  Timer? recordingTimer;

  int enabledIndex = 0;
  late List<CameraDescription> cameras;

  late CameraController _controller;



  Timer? _timer;

  bool scroll = true;

  @override
  Widget build(BuildContext context) {
    final cameraProvider = Provider.of<CameraProvider>(context);
    return _assetsLoaded
        ? Scaffold(
            body: Center(
              child: spinkit,
            ),
          )
        : !cameraProvider.isCameraInitialized
            ? Scaffold(
                body: Center(
                  child: spinkit,
                ),
              )
            : Scaffold(
                backgroundColor: Colors.black,
                body:
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: [
                      !isExpanded
                          ? SizedBox()
                          : Positioned(
                        bottom: 0,
                        top: 0,
                        left: 0,
                        right: 0,
                        child: CameraPreview(cameraProvider.cameraController!),
                      ),
                      Column(
                        children: [
                          Expanded(
                            flex: 6,
                            child: isExpanded
                                ? SizedBox()
                                : Container(
                              // height: MediaQuery.sizeOf(context).height * 0.6,
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
                                      height: MediaQuery.of(
                                          context)
                                          .size
                                          .height *
                                          0.4,
                                      width: MediaQuery.of(
                                          context)
                                          .size
                                          .width *
                                          0.4,
                                      gaplessPlayback: true,
                                    ),
                                    bottom: -30,
                                    left: 0,
                                    right: 0,
                                  ),
                                  Positioned(
                                    child: InkWell(
                                      onTap: () async {
                                        await stop();
                                        stopSound();
                                        stopSoundN();
                                        if (recordingTimer !=
                                            null) {
                                          recordingTimer!.cancel();
                                          print(
                                              'recorder timer $recordingTimer');
                                        }
                                        setState(() {
                                          dancing = true;
                                          isSessionCleared = true;
                                          selectedAsset =
                                          dancingGifs[
                                          selectedIndex!];
                                          selectedVoice =
                                          animalsVoices[
                                          selectedIndex!];
                                        });
                                        // await voicePlayer.open(Audio(selectedVoice!));
                                        playSound(selectedVoice!);
                                      },
                                      child: selectedAsset == null
                                          ? SizedBox()
                                          : Image.asset(
                                        'assets/speaker.png',
                                        width: MediaQuery.of(
                                            context)
                                            .size
                                            .width *
                                            0.14,
                                        height: MediaQuery.of(
                                            context)
                                            .size
                                            .height *
                                            0.14,
                                      ),
                                    ),
                                    bottom: MediaQuery.of(context)
                                        .size
                                        .width *
                                        0.1,
                                    right: MediaQuery.of(context)
                                        .size
                                        .width *
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
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      height: MediaQuery.of(context).size.width * 0.35,
                                      child: CameraPreview(cameraProvider.cameraController!,),
                                    ),


                                    top: 0,
                                    right: 0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(
                              width: double.infinity,
                              // height: MediaQuery.sizeOf(context).height * 0.,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                image: DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                      lightBlue, BlendMode.lighten),
                                  image: AssetImage(
                                    'assets/greenBg.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  AnimatedBuilder(
                                    animation: _animationController!,
                                    builder: (BuildContext context,
                                        Widget? child) {
                                      return SlideTransition(
                                        position: _slideAnimation!,
                                        child: GridView.builder(
                                          padding: EdgeInsets.only(
                                              top: MediaQuery.sizeOf(
                                                  context)
                                                  .height *
                                                  0.05),
                                          itemCount: imagesList.length,
                                          shrinkWrap: true,
                                          gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            mainAxisExtent:
                                            MediaQuery.of(context)
                                                .size
                                                .height *
                                                0.09,
                                            mainAxisSpacing: 7,
                                            // crossAxisSpacing: 12,
                                          ),
                                          itemBuilder:
                                              (BuildContext context,
                                              int index) {
                                            // Create the button widget
                                            return index == 9 ||
                                                index == 11
                                                ? SizedBox()
                                                : Bounce(
                                              // Updated onTap function
                                              onTap: () async {
                                                if (!isExpanded) {
                                                  if (_buttonEnabled) {
                                                    if (recordingTimer !=
                                                        null) {
                                                      recordingTimer!
                                                          .cancel();
                                                      print(
                                                          'recorder timer $recordingTimer');
                                                    }

                                                    setState(() {
                                                      _buttonEnabled =
                                                      false;
                                                      // whileTrue = true;
                                                      dancing =
                                                      false;
                                                      selectedAsset =
                                                      gifAssetsHearing[
                                                      index];
                                                      backgroundAsset =
                                                      bgs[index];
                                                      selectedIndex =
                                                          index;
                                                    });
                                                    await stop();
                                                    stopSound();
                                                    stopSoundN();
                                                    recordingTimer = Timer.periodic(
                                                        Duration(
                                                            milliseconds:
                                                            250),
                                                            (timer) async {
                                                          if (isSessionCleared ==
                                                              true) {
                                                            isSessionCleared =
                                                            false;
                                                            // await stop();
                                                            // stopSound();
                                                            setState(
                                                                    () {
                                                                  _buttonEnabled =
                                                                  true;
                                                                  selectedAsset =
                                                                  gifAssetsHearing[
                                                                  selectedIndex!];
                                                                });
                                                            await record();
                                                            await Future.delayed(Duration(
                                                                seconds:
                                                                5));
                                                            await stop();
                                                            setState(
                                                                    () {
                                                                  selectedAsset = dancing ==
                                                                      false
                                                                      ? gifAssetsTalking[
                                                                  selectedIndex!]
                                                                      : dancingGifs[
                                                                  selectedIndex!];
                                                                });
                                                            dancing ==
                                                                false
                                                                ? playSoundFileN(
                                                                pathToAudio!.path)
                                                                : null;
                                                            await Future.delayed(Duration(
                                                                seconds:
                                                                5));
                                                            isSessionCleared =
                                                            true;
                                                          }
                                                        });
                                                    enabledIndex =
                                                        index;
                                                    print(
                                                        'enable index $enabledIndex');
                                                  } else {
                                                    // showToast(context, 'button disabled');
                                                  }
                                                } else {}
                                              },

                                              duration: Duration(
                                                  milliseconds:
                                                  300),
                                              child: Container(
                                                decoration:
                                                BoxDecoration(
                                                    color: Colors
                                                        .white,
                                                    shape: BoxShape
                                                        .circle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors
                                                            .black26,
                                                        spreadRadius:
                                                        3,
                                                        blurRadius:
                                                        15,
                                                        offset:
                                                        Offset(
                                                            0,
                                                            3),
                                                      ),
                                                    ]),
                                                child: Center(
                                                  child:
                                                  Image.asset(
                                                    imagesList[
                                                    index],
                                                    width: index ==
                                                        10
                                                        ? MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        0.12
                                                        : MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        0.14,
                                                    height: index ==
                                                        10
                                                        ? MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        0.12
                                                        : MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        0.14,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: InkWell(
                                      onTap: () {
                                        if (recordingTimer != null) {
                                          recordingTimer!.cancel();
                                          print(
                                              'recorder timer $recordingTimer');
                                        }
                                        setState(() {
                                          selectedAsset = null;
                                          isExpanded = !isExpanded;
                                        });
                                        stop();
                                        stopSound();
                                        stopSoundN();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(50),
                                          color: yellowish,
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.symmetric(
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
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
  }
}
