import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'launch.dart';
import 'splash.dart';

class StartupSplashScreen extends StatefulWidget {
  StartupSplashScreen({Key key}) : super(key: key);
  @override
  _StartupSplashScreenState createState() => _StartupSplashScreenState();
}

class _StartupSplashScreenState extends State<StartupSplashScreen> {

  Future<int> starter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('firstTime');

    //Theme integer is 8 bits - two bits(4 values) per page theme
    int themeInteger = prefs.getInt('theme');
    if (themeInteger == null) {
      themeInteger = 0;
      prefs.setInt('theme', themeInteger);
    }

    if (firstTime != null && !firstTime) {// Not first time
      print("0");
      return 0;
    } else {// First time
      print("1");
      prefs.setBool('firstTime', false);
      return 1;
    }
  }

  Future<void> reRoute() async {
    int first = await starter();
    if (first == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LaunchScreen()),
      );
    }
    else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => SplashScreen()),
      );
    }
  }


  @override
  Widget build(BuildContext context) {

    reRoute();
    return Scaffold(
      body: Center(
        child: Container(
          child: Text(
            "Loading...",
            style: TextStyle(
                fontSize: 36,
                fontFamily: 'BungeeInline'
            ),
          ),
        ),
      ),
    );
  }
}