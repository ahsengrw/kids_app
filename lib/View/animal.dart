import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bounce_button/bounce_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gif/gif.dart';
import 'package:kids_app/SharedContent/constants.dart';

class Animals extends StatefulWidget {
  const Animals({Key? key}) : super(key: key);

  @override
  State<Animals> createState() => _AnimalsState();
}

class _AnimalsState extends State<Animals> with TickerProviderStateMixin {
  List<String> gifAssets = [
    'assets/cat.gif',
    'assets/cow.gif',
    'assets/dog.gif',
    'assets/duck.gif',
    'assets/giraffe.gif',
    'assets/hen.gif',
    'assets/monkey.gif',
    'assets/zebra.gif',
    'assets/bird.gif',
  ];

  List<String> animalsVoices = [
    "assets/Animals Voices/cat.wav",
    "assets/Animals Voices/cow.wav",
    "assets/Animals Voices/dog.wav",
    "assets/Animals Voices/duck.wav",
    "assets/Animals Voices/giraffe.wav",
    "assets/Animals Voices/hen.wav",
    "assets/Animals Voices/monkey.wav",
    "assets/Animals Voices/zebra.wav",
    "assets/Animals Voices/bird.wav",
  ];

  String? selectedVoice;

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
  ];

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
  int _fps = 22;

  @override
  void initState() {
    precacheAudioAssets(imagesList);
    precacheAudioAssets(animalsVoices);
    precacheAudioAssets(gifAssets);
    controller1 = GifController(vsync: this);
    setState(() {
      assetsLoading = false;
    });
    super.initState();
  }

  @override
  void dispose() {
    controller1.dispose();
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
                  Container(
                    height: 155,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(
                      horizontal: 21,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: darkBlue,
                        width: 5,
                      ),
                    ),
                    child: selectedAsset == null
                        ? SizedBox()
                        : Gif(
                            onFetchCompleted: () {
                              AssetsAudioPlayer.newPlayer().open(
                                Audio(selectedVoice!),
                              );
                            },
                            controller: controller1,
                            autostart: Autostart.once,
                            fps: _fps,
                            placeholder: (context) => Center(
                                child: SpinKitThreeBounce(
                              color: redishOrange,
                              size: 20,
                            )),
                            image: AssetImage(selectedAsset!),
                          ),
                  ),
                  SizedBox(
                    height: 21,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 21.0),
                    child: GridView.builder(
                      itemCount: imagesList.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisExtent: MediaQuery.of(context).size.height * 0.116,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        // Create the button widget
                        return Bounce(
                          duration: Duration(
                            milliseconds: 300,
                          ),
                          onTap: () async {
                            print('working outside');
                            if (_buttonEnabled) {
                              print('Working inside');
                              setState(() {
                                selectedAsset = gifAssets[index];
                                selectedVoice = animalsVoices[index];
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
                          child: Container(
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
                              child: Image.asset(
                                imagesList[index],
                                width: 50,
                                height: 50,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
