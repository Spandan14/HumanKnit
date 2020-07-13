import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          children: <Widget>[
            new Image.asset('assets/images/logo.png', width:100, alignment: Alignment(0,0),),
          ],
        )
      )
    );
  }
}
