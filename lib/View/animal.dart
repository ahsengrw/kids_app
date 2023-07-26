import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bounce_button/bounce_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gif/gif.dart';
import 'package:kids_app/SharedContent/constants.dart';

class Animals extends StatefulWidget {
  const Animals({Key? key}) : super(key: key);

  @override
  State<Animals> createState() => _AnimalsState();
}

class _AnimalsState extends State<Animals> with TickerProviderStateMixin {

  String base = 'assets/animals_waving/';
  List<String> gifAssets = [
    'assets/animals_waving/cat.gif',
    'assets/animals_waving/cow.gif',
    'assets/animals_waving/dog.gif',
    'assets/animals_waving/duck.gif',
    'assets/animals_waving/giraffe.gif',
    'assets/animals_waving/hen.gif',
    'assets/animals_waving/monkey.gif',
    'assets/animals_waving/zebra.gif',
    'assets/animals_waving/bird.gif',
    '',
    'assets/animals_waving/elephant.gif',
    '',

  ];

  List<String> animalsVoices = [
    "assets/Animals_Voices/cat.wav",
    "assets/Animals_Voices/cow.wav",
    "assets/Animals_Voices/dog.wav",
    "assets/Animals_Voices/duck.wav",
    "assets/Animals_Voices/giraffe.wav",
    "assets/Animals_Voices/hen.wav",
    "assets/Animals_Voices/monkey.wav",
    "assets/Animals_Voices/zebra.wav",
    "assets/Animals_Voices/bird.wav",
    "assets/Animals_Voices/bird.wav",
    "assets/Animals_Voices/elephant.wav",
    "assets/Animals_Voices/bird.wav",
  ];



  String? selectedVoice;
  String? selectedName;

  List<String> imagesList = [
    'assets/animals_icons/Cat.png',
    'assets/animals_icons/Cow.png',
    'assets/animals_icons/Dog.png',
    'assets/animals_icons/Duck.png',
    'assets/animals_icons/Giraffe.png',
    'assets/animals_icons/Hen.png',
    'assets/animals_icons/Monkey.png',
    'assets/animals_icons/Zebra.png',
    'assets/animals_icons/Bird.png',
    '',
    'assets/animals_icons/Elephant.png',
    '',
  ];

  List<String> animalsNamesList = [
    'assets/Animals_Names/cat.wav',
    'assets/Animals_Names/cow.mp3',
    'assets/Animals_Names/dog.wav',
    'assets/Animals_Names/duck.mp3',
    'assets/Animals_Names/giraffe.mp3',
    'assets/Animals_Names/hen.mp3',
    'assets/Animals_Names/monkey.mp3',
    'assets/Animals_Names/zebra.mp3',
    'assets/Animals_Names/bird.mp3',
    '',
    'assets/Animals_Names/elephant.mp3',
    '',
  ];


  final assetAudioPlayerN = AssetsAudioPlayer();

   playSound(String path) {
    print('sound played of asset...................');
    assetAudioPlayerN.open(Audio(path));
  }


  void stopSound() {
    print('sound stopped...................');
    assetAudioPlayerN.stop();
  }

  Future<void> precacheAudioAssets(List<String> assetUrls) async {
    for (var url in assetUrls) {
      await DefaultCacheManager().downloadFile(url);
    }
  }

  final spinkit = SpinKitFadingCircle(
    color: redishOrange,
    size: 50.0,
  );



  String? selectedAsset;

  late final GifController controller1;
  int _fps = 30;
  AnimationController? _animationController;
  Animation<Offset>? _slideAnimation;

  AssetsAudioPlayer voicePlayer = AssetsAudioPlayer.newPlayer();
  AssetsAudioPlayer namePlayer = AssetsAudioPlayer.newPlayer();

  @override
  void initState() {
    // precacheAudioAssets(imagesList);
    // precacheAudioAssets(animalsVoices);
    // precacheAudioAssets(animalsNamesList);
    // precacheAudioAssets(gifAssets);

    controller1 = GifController(vsync: this);
    setState(() {
      assetsLoading = false;
    });
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
    super.initState();
  }

  @override
  void dispose() {
    voicePlayer.dispose();
    namePlayer.dispose();
    assetAudioPlayerN.dispose();
    controller1.dispose();
    _animationController!.dispose();
    super.dispose();
  }

  bool assetsLoading = true;

  bool showProgress = false;

  bool _buttonEnabled = true;



  @override
  Widget build(BuildContext context) {
    return assetsLoading
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
                      ColorFilter.mode(redishOrange, BlendMode.lighten),
                  image: AssetImage(
                    'assets/greenBg.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 21),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: darkBlue,
                            width: 5,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: selectedAsset == null
                            ? SizedBox()
                            : Container(
                          height: 300, // Set the desired height here
                          child: Gif(
                            onFetchCompleted: () async {

                         try {
                           await voicePlayer.open(Audio(selectedVoice!));

                           // Add a 1-second delay using Future.delayed
                           await Future.delayed(Duration(seconds: 1));

                           await namePlayer.open(Audio(selectedName!));
                         } on Exception catch (e) {
                           // TODO
                           print('Error **********$e');
                         }
                            },
                            controller: controller1,
                            autostart: Autostart.once,
                            fps: _fps,
                            placeholder: (context) => Center(
                              child: SpinKitThreeBounce(
                                color: darkBlue,
                                size: 20,
                              ),
                            ),
                            image: AssetImage(selectedAsset!),
                          ),
                        ),
                      ),
                    ],
                  ),
                  AnimatedBuilder(
                    animation: _animationController!,
                    builder: (BuildContext context, Widget? child) {
                      return  SlideTransition(
                        position: _slideAnimation!,
                        child:  GridView.builder(
                          itemCount: imagesList.length,
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisExtent: MediaQuery.of(context).size.height * 0.09,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            // Create the button widget
                            return Bounce(
                              duration: Duration(
                                milliseconds: 300,
                              ),
                              onTap:index== 9 || index == 11 ? (){} : () async {

                                print('working outside');
                                if (_buttonEnabled) {
                                  print('Working inside');

                                  setState(() {
                                    voicePlayer.stop();
                                    namePlayer.stop();
                                    selectedAsset = gifAssets[index];
                                    selectedVoice = animalsVoices[index];
                                    selectedName = animalsNamesList[index];
                                    _buttonEnabled = false; // disable the button
                                  });

                                  Timer(Duration(seconds: 2), () {
                                    print('timer complete');
                                    setState(() {
                                      _buttonEnabled = true;
                                    });
                                  });
                                } else {}
                              },
                              child:index ==9  || index == 11 ? SizedBox() :  Container(
                                decoration: BoxDecoration(
                                    color: yellowish,
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
                                  child:
                                  AnimatedOpacity(
                                    opacity: 1.0,
                                    duration: Duration(seconds: 3),
                                    curve: Curves.easeIn,
                                    child: Image.asset(
                                      imagesList[index],
                                      width: index == 10 ? MediaQuery.of(context).size.width * 0.12 :  MediaQuery.of(context).size.width * 0.14,
                                      height: index == 10 ? MediaQuery.of(context).size.width * 0.12 :  MediaQuery.of(context).size.width * 0.14,


                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
  }
}
