import 'dart:async';
import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bounce_button/bounce_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:kids_app/SharedContent/constants.dart';
import 'package:kids_app/View/call_dialog.dart';
import 'package:provider/provider.dart';
import '../SharedContent/call_button.dart';
import '../State Management/play_stop_bg_music.dart';

class PhonePad extends StatefulWidget {
  const PhonePad({Key? key}) : super(key: key);

  @override
  State<PhonePad> createState() => _PhonePadState();
}

class _PhonePadState extends State<PhonePad> {
  String _numberSequence = '';



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


  Future<void> precacheAudioAssets(String url) async {
    await DefaultCacheManager().downloadFile(url);
    setState(() {
      dataLoading = false;
    });
  }


  Future<void> precacheAudioAssetsList(List<String> assetUrls) async {
    for (var url in assetUrls) {
      await DefaultCacheManager().downloadFile(url);
    }
  }

  bool dataLoading = true;
  @override
  void initState() {
    precacheAudioAssets('assets/dial.mp3');
    precacheAudioAssetsList(music);
    // TODO: implement initState
    super.initState();
  }

  List<String> music = [
    'assets/dance.mp3','assets/music2.mp3','assets/music1.mp3',

  ];


  final assetAudioPlayer = AssetsAudioPlayer();

  void playSound(String path) {
    print('sound played of asset...................');
    assetAudioPlayer.open(Audio(path));
  }

  void stopSound() {
    print('sound stopped...................');
    assetAudioPlayer.stop();
  }
  int? _newLetterIndex;


  void _onButtonPress(String label) {
    setState(() {
      if (label == 'backspace') {
        _numberSequence = _numberSequence.substring(0, _numberSequence.length - 1);
      } else if (label == 'call') {
        // call function here
      } else {
        _numberSequence += label;
        // Set the index of the newly added letter
        _newLetterIndex = _numberSequence.length - 1;
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    final audioModel = Provider.of<AudioModel>(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/greenBg.png'),
              colorFilter: ColorFilter.mode(darkGreen, BlendMode.lighten),
          fit: BoxFit.cover,
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 80,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 21, vertical: 21),
              decoration: BoxDecoration(
                color: darkBrown,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Color(0xffDE611E),
                  width: 5,
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 12,
              ),
              child: Center(
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                    child: RichText(
                      key: ValueKey<String>(_numberSequence),
                      text: TextSpan(
                        style: customStyle.copyWith(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                        children: List.generate(_numberSequence.length, (index) {
                          final letter = _numberSequence[index];
                          final isAnimated = index == _numberSequence.length - 1;

                          return TextSpan(
                            text: letter,
                            style: TextStyle(
                              fontSize: isAnimated ? 34 : 34,
                              fontWeight: isAnimated ? FontWeight.bold : FontWeight.bold,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),


              ),
            ),
            Wrap(

              alignment: WrapAlignment.center,
              spacing: MediaQuery.of(context).size.width * 0.1,
              runSpacing: 7,
              crossAxisAlignment: WrapCrossAlignment.center,

              children: List.generate(12, (index) {
                String label;
                double containerWidth;
                double containerHeight;
                switch (index) {
                  case 9:
                    label = '*';
                    containerWidth = MediaQuery.of(context).size.height * 0.09;
                    containerHeight = MediaQuery.of(context).size.height * 0.09;
                    break;
                  case 10:
                    label = '0';
                    containerWidth = MediaQuery.of(context).size.height * 0.11;
                    containerHeight = MediaQuery.of(context).size.height * 0.11;
                    break;
                  case 11:
                    label = '#';
                    containerWidth = MediaQuery.of(context).size.height * 0.09;
                    containerHeight = MediaQuery.of(context).size.height * 0.09;
                    break;
                  default:
                    label = (index + 1).toString();
                    containerWidth = MediaQuery.of(context).size.height * 0.11;
                    containerHeight = MediaQuery.of(context).size.height * 0.11;
                }
                return Bounce(
                  duration: Duration(milliseconds: 100),
                  onTap: () {
                    _onButtonPress(label);
                  },
                  child: index == 9 || index == 11
                      ? Container(
                    width: containerWidth,
                    height: containerHeight,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 3,
                          blurRadius: 15,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        index == 9 ? '*' : '#',
                        style: customStyle.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 40,
                          color: redishOrange,
                        ),
                      ),
                    ),
                  )
                      : Container(
                    width: containerWidth,
                    height: containerHeight,
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
                      ],
                    ),
                    child: Center(
                      child: Text(
                        label,
                        style: customStyle.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize: 50,
                          color: redishOrange,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(
              height: 21,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Spacer(),
                  // SizedBox(
                  //   width: 61,
                  // ),
                  CallButton(
                    onTap: () async {
                      audioModel.stopAudio();
                      final random = Random();
                    String  selectedAsset = imagesList[random.nextInt(imagesList.length)];
                      final List<Color> colors = [color1,color2,color3,color4,color5,];
                      final randomColor = colors[random.nextInt(colors.length)];
                      final randomMusic = music[random.nextInt(music.length)];


                      playSound('assets/dial.mp3');
                      setState(() {
                        _numberSequence = '';
                      });
                      showDialog(
                          context: context,
                          builder: (context) {
                            return CallDialog(
                              popCall: (){
                               stopSound();
                                Navigator.pop(context);
                              },
                              bgColor: randomColor,
                              assets:selectedAsset ,
                            );
                          });
                    },
                    buttonColor: darkPurple,
                    iconColor: redishOrange,
                  ),
                  // Spacer(),
                  // TextButton(
                  //   onPressed: () {
                  //     setState(() {
                  //       _numberSequence = '';
                  //     });
                  //   },
                  //   child: Text('Clear'),
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


Color color1 = Color(0xffE4C1F9);
Color color2 = Color(0xffFCF6BD);
Color color3 = Color(0xffD0F4DE);
Color color4 = Color(0xffA9DEF9);
Color color5 = Color(0xffFFADAD);
