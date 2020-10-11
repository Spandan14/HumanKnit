import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:humanknit/editprofile.dart';
import 'package:humanknit/friendsview.dart';
import 'package:humanknit/makefriends.dart';
import 'package:humanknit/stats.dart';
import 'addpost.dart';

class GoalsPage extends StatefulWidget {
  @override
  _GoalsPageState createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {






  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Scaffold goalPicked = Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 40/692 * height),
            child: Container(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Current Goal",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "PatrickHand",
                      fontSize: 40,
                      color: Color.fromRGBO(0, 206, 201, 1)
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 40/692 * height),
            child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(100),
                  color: Color.fromRGBO(253, 203, 110, 1)
                ),
              height: 80/692 * height,
              width: 320/360 * width,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  "Feed 100 Homeless People In Vernon Hills",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "PatrickHand",
                    fontSize: 24
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20/692 * height),
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(100),
                  color: Color.fromRGBO(250, 177, 160, 1)
              ),
              height: 80/692 * height,
              width: 320/360 * width,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Your Likes This Month",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "PatrickHand",
                          fontSize: 24
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2,
                        color: Colors.white
                      )
                    ),
                    height: 100/692 * height,
                    width: 50/360 * width,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.favorite,
                          color: Colors.redAccent,
                          size: 40,
                        ),
                        Text(
                          5.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "AdventPro",
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );


    Scaffold goalVoting = Scaffold(
      body: Column(

      ),
    );

    return goalPicked;
  }
}
