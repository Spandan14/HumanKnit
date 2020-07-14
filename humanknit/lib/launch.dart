import 'package:flutter/material.dart';

class LaunchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final text = Text(
      "The best way to get involved in your community",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 24 / 896 * screenHeight,
        color: Color(0xff6c7bff),
      ),
    );

    final getStartedButton = FlatButton(
      color: Color(0xff6c7bff),
      padding: EdgeInsets.all(20),
      onPressed: () {},
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
              Image.asset(
                "assets/images/logo.png",
                height: 400 / 896 * screenHeight,
                width: 400 / 896 * screenHeight,
              ),
              text,
              Container(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
