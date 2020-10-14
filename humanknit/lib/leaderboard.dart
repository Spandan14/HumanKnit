import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:humanknit/editprofile.dart';
import 'package:humanknit/friendsview.dart';
import 'package:humanknit/makefriends.dart';
import 'package:humanknit/stats.dart';
import 'addpost.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Scaffold leaderboard = Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 40 / 692 * height),
            child: Container(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Likes Leaderboard",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "PatrickHand",
                      fontSize: 40,
                      color: Color.fromRGBO(0, 206, 201, 1)),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 40 / 692 * height),
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.lightBlue),
              height: 80 / 692 * height,
              width: 320 / 360 * width,
              child: Align(
                alignment: Alignment.center,
                child: ListTile(
                  leading: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: new BoxDecoration(
                      color: Color(0xFFFDCB6E),
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: Text(
                    "Frank Gao",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "PatrickHand",
                      fontSize: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 40 / 692 * height),
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.lightBlue),
              height: 80 / 692 * height,
              width: 320 / 360 * width,
              child: Align(
                alignment: Alignment.center,
                child: ListTile(
                  leading: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: new BoxDecoration(
                      color: Color(0xFFC0C0C0),
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: Text(
                    "Spandan Goel",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "PatrickHand",
                      fontSize: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 40 / 692 * height),
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.lightBlue),
              height: 80 / 692 * height,
              width: 320 / 360 * width,
              child: Align(
                alignment: Alignment.center,
                child: ListTile(
                  leading: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: new BoxDecoration(
                      color: Color(0xFFCD7F32),
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: Text(
                    "Your Mom",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "PatrickHand",
                      fontSize: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return leaderboard;
  }
}
