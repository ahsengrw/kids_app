import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:kids_app/SharedContent/constants.dart';
import 'package:kids_app/State%20Management/camera_provider.dart';
import 'package:kids_app/View/bottom_navbar.dart';
import 'package:provider/provider.dart';

import '../State Management/play_stop_bg_music.dart';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Provider.of<CameraProvider>(context,listen: false).initCamera();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return BottomNavBar();
      }));
    });
    final audioModel = Provider.of<AudioModel>(context, listen: false);
    audioModel.playAudio();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(child:  TextLiquidFill(
      text: 'Kids Phone',
        waveColor: yellowish,
        boxBackgroundColor: Colors.white,
        textStyle: customHeadingStyle.copyWith(
          fontSize: MediaQuery.of(context).size.height * 0.07,
          fontFamily: 'Pacifico',),
        // boxHeight: 200.0,
      ),
            bottom: MediaQuery.of(context).size.height * 0.4,
            left: 0,
            right: 0,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 9,
            child: Image.asset(
              'assets/splashscreen.gif',
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
