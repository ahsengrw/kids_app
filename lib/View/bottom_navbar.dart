import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:kids_app/SharedContent/constants.dart';
import 'package:kids_app/SharedContent/password_dialog.dart';
import 'package:kids_app/View/about_us.dart';
import 'package:kids_app/View/phone_pad.dart';
import 'package:kids_app/View/settings_screen.dart';
import 'package:kids_app/View/counting.dart';
import 'package:kids_app/View/animal.dart';
import 'package:kids_app/View/camera_screen.dart';
import 'package:provider/provider.dart';

import '../State Management/play_stop_bg_music.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  final _pageOptions = [
    PhonePad(),
    Counting(),
    Animals(),
    CameraScreen(),
  ];

  final List _imageOptions = [
    'assets/call_icon.png',
    'assets/123.png',
    'assets/monkey.png',
  'assets/xoxo.png',
  ];

  playMusic() {
    AssetsAudioPlayer.newPlayer().open(
      Audio('assets/bg.mp3'),
    );
  }

  @override
  void initState() {
    // playMusic();
    // TODO: implement initState
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final audioModel = Provider.of<AudioModel>(context);
    return Scaffold(
      drawerEdgeDragWidth: 0,
      key: _scaffoldKey,
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 31,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(Icons.close),
                ),
              ),
            ),
            // SizedBox(
            //   height: 31,
            // ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Settings();
                }));
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.info),
            //   title: Text('About Us'),
            //   onTap: () {
            //     Navigator.push(context, MaterialPageRoute(builder: (context) {
            //       return AboutUs();
            //     }));
            //   },
            // ),
          ],
        ),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(36.0),
        child: AppBar(
          backgroundColor: customYellow,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              onTap: () {
                print('working');
                showDialog(
                    context: context,
                    builder: (context) {
                      return PasscodeDialog(
                        onEnter: () {
                          Navigator.pop(context);
                          _scaffoldKey.currentState!.openDrawer();
                        },
                      );
                    });
              },
              child: Image.asset(
                'assets/drawer.png',
                width: 18,
                height: 18,
              ),
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                audioModel.toggleAudio();
                setState(() {

                });
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.asset(
                  audioModel.isPlaying
                      ? 'assets/music_icon.png'
                      : 'assets/music_off.png',
                  color: redishOrange,
                  width: 22,
                  height: 22,
                ),
              ),
            ),
          ],
        ),
      ),
      body: _pageOptions[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor:_selectedIndex == 0 ?  darkGreen : _selectedIndex ==1 ? darkBlue : _selectedIndex ==2 ? redishOrange  : lightBlue,
        items: <Widget>[
          Image.asset(_imageOptions[0],width: 40,height: 40,),
          Image.asset(_imageOptions[1],width: 40,height: 40,),
          Image.asset(_imageOptions[2],width: 40,height: 40,),
          Image.asset(_imageOptions[3],width: 40,height: 40,),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          //Handle button tap
        },
      ),
    );
  }
}
