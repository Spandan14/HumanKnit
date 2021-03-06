import 'package:flutter/material.dart';
import 'package:humanknit/login.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' show Platform, File;
import 'dart:async' show Timer;
import 'package:shared_preferences/shared_preferences.dart';


class LaunchScreen extends StatefulWidget {
  State<StatefulWidget> createState() {
    return LaunchScreenState();
  }
}

class LaunchScreenState extends State<LaunchScreen> with SingleTickerProviderStateMixin {
  AnimationController offsetController;
  Animation<Offset> offsetAnimationLogo;
  Animation<Offset> offsetAnimationButton;
  Animation fadeAnimation;



  @override
  void initState() {

      super.initState();
      offsetController = AnimationController(
        duration: const Duration(seconds: 3),
        vsync: this,
      );
      offsetAnimationLogo = Tween<Offset>(
        begin: Offset(0.0, -1.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: offsetController,
        curve: Curves.elasticOut,
      ));
      offsetAnimationButton = Tween<Offset>(
        begin: Offset(0.0, 2.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: offsetController,
        curve: Curves.elasticOut,
      ));
      fadeAnimation = Tween(
        begin: 0.0,
        end: 1.0,
      ).animate(offsetController);
      offsetController.forward();

  }

  @override
  void dispose() {
    offsetController.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final text = Text(
      "The best way to get involved in your community",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 24 / 896 * screenHeight,
        color: Color.fromRGBO(0, 206, 201, 1),
      ),
    );

    final getStartedButton = FlatButton(
      color: Color.fromRGBO(0, 206, 201, 1),
      padding: EdgeInsets.all(20),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      },
      child: Text("Get started",
          style: TextStyle(
              fontSize: 24 / 896 * screenHeight, color: Color(0xffffffff))),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    );

      return MaterialApp(

        theme: ThemeData(fontFamily: 'BungeeInline'),
        home: Scaffold(
          body: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SlideTransition(
                  position: offsetAnimationLogo,
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: 400 / 896 * screenHeight,
                    width: 400 / 896 * screenHeight,
                  ),
                ),
                FadeTransition(
                  opacity: fadeAnimation,
                  child: text,
                ),
                SlideTransition(
                  position: offsetAnimationButton,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff000000),
                          blurRadius: 10,
                          offset: Offset(
                            0,
                            4,
                          ),
                        ),
                      ],
                    ),
                    child: getStartedButton,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
}
