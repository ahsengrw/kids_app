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

class _PhonePadState extends State<PhonePad> with SingleTickerProviderStateMixin {
  String _numberSequence = '';



  List<String> imagesList = [
    'assets/animals_talking/cat.gif',
    'assets/animals_talking/bird.gif',
    'assets/animals_talking/cow.gif',
    'assets/animals_talking/dog.gif',
    'assets/animals_talking/duck.gif',
    'assets/animals_talking/giraffe.gif',
    'assets/animals_talking/hen.gif',
    'assets/animals_talking/monkey.gif',
    'assets/animals_talking/zebra.gif',
    'assets/animals_talking/elephant.gif',
  ];

  List<String> countingVoices = [
    'assets/counting_voices/1.wav',
    'assets/counting_voices/2.wav',
    'assets/counting_voices/3.wav',
    'assets/counting_voices/4.wav',
    'assets/counting_voices/5.wav',
    'assets/counting_voices/6.wav',
    'assets/counting_voices/7.wav',
    'assets/counting_voices/8.wav',
    'assets/counting_voices/9.wav',
    'assets/counting_voices/9.wav',
    'assets/counting_voices/0.wav',
    'assets/counting_voices/9.wav',
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


  AnimationController? _animationController;
  Animation<Offset>? _slideAnimation;

  bool dataLoading = true;
  @override
  void initState() {
    super.initState();
     audioModel = Provider.of<AudioModel>(context,listen: false);
     if(audioModel!.isPlaying){
       wasPlayed = true;
     }else{
       wasPlayed = false;
     }
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
    precacheAudioAssets('assets/dial.mp3');
    precacheAudioAssetsList(music);
  }

  List<String> music = [
    'assets/dance.mp3','assets/music2.mp3','assets/music1.mp3',

  ];

  @override
  void dispose() {
    super.dispose();
    _animationController!.dispose();
  }


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


  void _onButtonPress(String label,int index) {
    setState(() {
      if (label == 'backspace') {
        _numberSequence = _numberSequence.substring(0, _numberSequence.length - 1);
      } else if (label == 'call') {
        // call function here
      } else {
        _numberSequence += label;
        // Set the index of the newly added letter
        _newLetterIndex = _numberSequence.length - 1;

        if(index != 9 && index != 11){
          setState(() {
            selectedVoice = countingVoices[index];
          });
          AssetsAudioPlayer.newPlayer().open(
            Audio(selectedVoice!),
          );
        }
      }
    });
  }

  String? selectedVoice;
  AudioModel? audioModel ;



  @override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

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
              height: screenHeight * 0.15,
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
                      maxLines: 1,
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
            AnimatedBuilder(
              animation: _animationController!,
              builder: (BuildContext context, Widget? child) {
                return  SlideTransition(
                  position: _slideAnimation!,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: screenWidth * 0.13,
                    runSpacing: 7,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: List.generate(12, (index) {
                      String label;
                      double containerWidth;
                      double containerHeight;
                      switch (index) {
                        case 9:
                          label = '*';
                          containerWidth = MediaQuery.of(context).size.height * 0.08;
                          containerHeight = MediaQuery.of(context).size.height * 0.08;
                          break;
                        case 10:
                          label = '0';
                          containerWidth = MediaQuery.of(context).size.height * 0.10;
                          containerHeight = MediaQuery.of(context).size.height * 0.10;
                          break;
                        case 11:
                          label = '#';
                          containerWidth = MediaQuery.of(context).size.height * 0.08;
                          containerHeight = MediaQuery.of(context).size.height * 0.08;
                          break;
                        default:
                          label = (index + 1).toString();
                          containerWidth = MediaQuery.of(context).size.height * 0.10;
                          containerHeight = MediaQuery.of(context).size.height * 0.10;
                      }
                      return Bounce(
                        duration: Duration(milliseconds: 400),
                        onTap: () {
                          _onButtonPress(label,index);
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
                            child: AnimatedDefaultTextStyle(
                              style: customStyle.copyWith(
                                fontWeight: FontWeight.w900,
                                fontSize: 50,
                                color: redishOrange,
                              ),
                              duration: Duration(milliseconds: 300),
                              child: Text(
                                label,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                );
              },
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
                      wasPlayed = audioModel!.isPlaying;
                      audioModel!.stopAudio();
                      final random = Random();
                    String  selectedAsset = imagesList[random.nextInt(imagesList.length)];
                      final List<Color> colors = [color1,color2,color3,color4,color5,];
                      final randomColor = colors[random.nextInt(colors.length)];
                      // final randomMusic = music[random.nextInt(music.length)];
                      playSound('assets/dial.mp3');
                      setState(() {
                        _numberSequence = '';
                      });
                      showDialog(
                        barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return WillPopScope(
                              onWillPop: () async {
                                // Handle back button press
                                // Return true to prevent the dialog from being dismissed
                                // Return false to allow the dialog to be dismissed
                                return false;
                              },
                              child: CallDialog(
                                popCall: (){
                                 stopSound();
                                  Navigator.pop(context);
                                  if (wasPlayed) {
                                    audioModel!.playAudio();
                                  }
                                },
                                bgColor: randomColor,
                                assets:selectedAsset ,
                              ),
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

  bool wasPlayed = true;
}


Color color1 = Color(0xffE4C1F9);
Color color2 = Color(0xffFCF6BD);
Color color3 = Color(0xffD0F4DE);
Color color4 = Color(0xffA9DEF9);
Color color5 = Color(0xffFFADAD);
