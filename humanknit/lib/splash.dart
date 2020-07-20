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
  Future<void> reRoute() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      if (!user.isEmailVerified) {
        await emailVerify(user);
      }
      else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Navigation()),
        );
      }
    }
    else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoginScreen()),
      );
    }
  }

  Future<void>emailVerify(FirebaseUser user) async
  {
    user.sendEmailVerification();
    try {
      showDialog(
        barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData (
                  fontFamily: 'BungeeInline'
              ),
              child: AlertDialog (
                backgroundColor: Color(0xfffeefb3),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.all(Radius.circular(20.0)),
                ),
                title: Text(
                  'Verify Email',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff875053),
                  ),
                ),
                content: Column (
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Please verify your email. We have sent you an email with a link to do so",
                      style: TextStyle(
                        color: Color(0xffaa767c),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Row (
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton(
                            child: Text(
                              'Log out',
                              style: TextStyle(
                                color: Color(0xff875053),
                              ),
                            ),
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                              Navigator.of(context).pop();
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                              return;
                            },
                          )
                        ]
                    ),
                  ],
                ),
              ),
            );
          }
      );
    } catch (e) {
      print("Error");
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
