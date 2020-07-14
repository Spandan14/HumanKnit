import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final logoImage = new Image.asset('assets/images/logo.png');

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print(width);
    print(height);
    return Container(
      color: Color.fromRGBO(255,255,255,1),
      child: Column(
        children: [
          Padding (
            child: Image.asset('assets/images/logo.png'),
            padding: EdgeInsets.only(left: 0.05*width, right: 0.05*width, top: 60)
          ),
        ],
      ),
    );
  }
}
