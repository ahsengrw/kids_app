import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kids_app/SharedContent/constants.dart';
import 'package:kids_app/View/bottom_navbar.dart';
import 'package:provider/provider.dart';

import '../State Management/play_stop_bg_music.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         Image.asset('assets/splashscreen.gif',width: double.infinity,height: 311,),
        ],
      ),
    );
  }
}
