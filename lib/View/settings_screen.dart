import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kids_app/SharedContent/constants.dart';
import 'package:provider/provider.dart';
import '../State Management/play_stop_bg_music.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  @override
  void initState() {
     audioModel = Provider.of<AudioModel>(context,listen: false);
     setState(() {
       _isBackgroundMusicEnabled = audioModel!.isPlaying ? true : false;
     });

    // TODO: implement initState
    super.initState();
  }

  AudioModel? audioModel;
  bool _isBackgroundMusicEnabled = true;
  // bool _isNotificationsEnabled = true;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BackButton(),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: customHeadingStyle,
                  ),
                  SizedBox(
                    height: 31,
                  ),
                  Row(
                    children: [
                      Text(
                        'Background Music',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: CupertinoSwitch(
                            value: _isBackgroundMusicEnabled,
                            activeColor: Colors.black,
                            onChanged: (value) {
                              setState(() {
                                _isBackgroundMusicEnabled = value;
                                if (_isBackgroundMusicEnabled) {
                                  // Call function when switch is turned ON
                                  audioModel!.playAudio();
                                } else {
                                  // Call function when switch is turned OFF
                                 audioModel!.stopAudio();
                                }
                              });
                            },
                          ),

                        ),
                      ),
                    ],
                  ),
                  // SizedBox(height: 16.0),
                  // Row(
                  //   children: [
                  //     Text(
                  //       'Notifications',
                  //       style: TextStyle(
                  //         fontSize: 18.0,
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.black,
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Align(
                  //         alignment: Alignment.centerRight,
                  //         child: CupertinoSwitch(
                  //           value: _isNotificationsEnabled,
                  //           activeColor: Colors.black,
                  //           onChanged: (value) {
                  //             setState(() {
                  //               _isNotificationsEnabled = value;
                  //             });
                  //           },
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
