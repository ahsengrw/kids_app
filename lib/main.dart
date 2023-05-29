import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kids_app/SharedContent/constants.dart';
import 'package:provider/provider.dart';

import 'State Management/play_stop_bg_music.dart';
import 'View/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: customYellow,
  ));
  runApp(
    ChangeNotifierProvider(
      create: (context) => AudioModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kids App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}


