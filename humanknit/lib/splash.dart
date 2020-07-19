import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'nav.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    FirebaseAuth.instance.currentUser().then((currentUser) => {
      if (currentUser == null) {
      Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LoginScreen()))
      }
      else {
      Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Navigation())),
      print(currentUser.email)
      }
    }).catchError((err) => print(err));
  }

  @override
  Widget build(BuildContext context) {
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
