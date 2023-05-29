import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bounce_button/bounce_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gif/gif.dart';
import 'package:kids_app/SharedContent/call_button.dart';
import 'package:kids_app/SharedContent/constants.dart';

class Counting extends StatefulWidget {
  const Counting({Key? key}) : super(key: key);

  @override
  State<Counting> createState() => _CountingState();
}

class _CountingState extends State<Counting> with TickerProviderStateMixin {
  List<String> gifAssets = [
    'assets/1.gif',
    'assets/2.gif',
    'assets/3.gif',
    'assets/4.gif',
    'assets/5.gif',
    'assets/6.gif',
    'assets/7.gif',
    'assets/8.gif',
    'assets/9.gif',
  ];

  List<String> countingVoices = [
    'assets/counting voices/1.wav',
    'assets/counting voices/2.wav',
    'assets/counting voices/3.wav',
    'assets/counting voices/4.wav',
    'assets/counting voices/5.wav',
    'assets/counting voices/6.wav',
    'assets/counting voices/7.wav',
    'assets/counting voices/8.wav',
    'assets/counting voices/9.wav',
  ];




  String? selectedAsset;

  late final GifController controller1;
  int _fps = 30;

  @override
  void initState() {
    controller1 = GifController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    controller1.dispose();
    super.dispose();
  }

  bool _buttonEnabled = true;

  String? selectedVoice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(darkBlue, BlendMode.lighten),
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
              padding: EdgeInsets.symmetric(
                horizontal: 12,
              ),
              child:

              selectedAsset == null
                  ? SizedBox()
                  : Gif(
                onFetchCompleted: (){
                  AssetsAudioPlayer.newPlayer().open(
                    Audio(selectedVoice!),
                  );
                },
                      controller: controller1,
                      autostart: Autostart.once,
                      fps: _fps,
                placeholder: (context) =>
                    Center(child: SpinKitThreeBounce(color: darkBlue,size: 20,),),
                      image: AssetImage(selectedAsset!),
                    ),
            ),
            SizedBox(
              height: 21,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21.0),
              child: GridView.builder(
                itemCount: gifAssets.length,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisExtent: MediaQuery.of(context).size.height * 0.116,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemBuilder: (BuildContext context, int index) {
                  String label;
                  double containerWidth;
                  switch (index) {
                    case 9:
                      label = '#';
                      containerWidth = 34;
                      break;
                    case 10:
                      label = '0';
                      containerWidth = 100;
                      break;
                    case 11:
                      label = '*';
                      containerWidth = 34;
                      break;
                    default:
                      label = (index + 1).toString();
                      containerWidth = 100;
                  }
                  return  Bounce(
                    duration: Duration(milliseconds: 300),
                    onTap: ()async{
                      if(_buttonEnabled){
                        setState(() {
                          selectedAsset = gifAssets[index];
                          selectedVoice = countingVoices[index];
                          _buttonEnabled = false; // disable the button
                        });

                        // start a 3-second timer to re-enable the button
                        Timer(Duration(seconds: 2), () {
                          setState(() {
                            _buttonEnabled = true;
                          });
                        });
                      }else{}
                    },
                    child: Container(
                              width: containerWidth,
                              decoration: BoxDecoration(
                                  color: lightBlue,
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
                                  child: Text(
                                label,
                                style: customStyle.copyWith(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 34,
                                  color: customYellow,
                                ),
                              )),
                            ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
