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

class GoalsPage extends StatefulWidget {
  @override
  _GoalsPageState createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  Future<bool> sendZipCode(String zipcode) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;
    DocumentReference communityDocument =
        await Firestore.instance.document("communities/$zipcode");
    DocumentReference userCommunityDocument =
        await Firestore.instance.document("communities/$zipcode/users/$uid");
    communityDocument.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        userCommunityDocument.get().then((userdatasnapshot) {
          if (!userdatasnapshot.exists) {
            Firestore.instance
                .document("communities/$zipcode/users/$uid")
                .setData({
              'user': uid,
            });
            Firestore.instance.document("users/$uid").updateData({
              'community': zipcode,
            });
          }
        });
      } else {
        Firestore.instance
            .collection("communities")
            .document("$zipcode")
            .setData({});
        Firestore.instance.document("communities/$zipcode/users/$uid").setData({
          'user': uid,
        });
        Firestore.instance.document("users/$uid").updateData({
          'community': zipcode,
        });
      }
    });
    return false;
  }

  bool isNew = null;
  Future<void> getUserComm() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;
    DocumentReference userDataDocument =
        await Firestore.instance.document("users/$uid");
    userDataDocument.get().then((datasnapshot) {
      print(datasnapshot.data['community']);
      bool first = false;
      if (isNew == null) first = true;
      isNew = datasnapshot.data['community'] == null;
      if (first) setState(() {});
    });
  }

  final TextEditingController _zip = TextEditingController();
  static final goalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Scaffold goalPicked = Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 40 / 692 * height),
            child: Container(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Current Goal",
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
                  color: Color.fromRGBO(253, 203, 110, 1)),
              height: 80 / 692 * height,
              width: 320 / 360 * width,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Feed 100 Homeless People In Vernon Hills",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: "PatrickHand", fontSize: 24),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20 / 692 * height),
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(100),
                  color: Color.fromRGBO(250, 177, 160, 1)),
              height: 80 / 692 * height,
              width: 320 / 360 * width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "Your Likes This Month",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: "PatrickHand", fontSize: 24),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 2, color: Colors.white)),
                    height: 100 / 692 * height,
                    width: 50 / 360 * width,
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
                              color: Colors.white),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Text(
              "New goals for November will be picked starting October 24th\n\n\nStay Tuned!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "AdventPro",
                  fontSize: 30,
                  color: Color.fromRGBO(0, 206, 203, 1)),
            ),
          ),
        ],
      ),
    );

    Scaffold goalVoting = Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 40 / 692 * height),
            child: Container(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Goals for November",
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
            padding: EdgeInsets.only(top: 20 / 692 * height),
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(100),
                  color: Color.fromRGBO(250, 177, 160, 1)),
              height: 80 / 692 * height,
              width: 320 / 360 * width,
              child: Row(
                children: <Widget>[
                  Stack(),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    Scaffold locationChoose = Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 150.0),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "Enter Zip Code",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "PatrickHand",
                    fontSize: 40,
                    color: Color.fromRGBO(0, 206, 201, 1)),
              ),
            ),
          ),
          Form(
            key: goalKey,
            child: Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Container(
                width: 200,
                child: TextFormField(
                  controller: _zip,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter a zip code";
                    } else if (!RegExp('[0-9]{5}').hasMatch(value) ||
                        value.length != 5) {
                      return "Incorrect zip code";
                    }
                    return null;
                  },
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 14,
                    height: 1.5,
                  ),
                  decoration: InputDecoration(
                      errorStyle: TextStyle(fontFamily: "Lato", fontSize: 8),
                      contentPadding:
                          const EdgeInsets.only(top: 4, bottom: 4, left: 15),
                      hintText: "Zip Code",
                      border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(100.0),
                          ),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(177, 177, 177, 1),
                            width: 0.5,
                          ))),
                ),
              ),
            ),
          ),
          Container(
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 0.20 * width, right: 0.20 * width, top: 30),
                  child: Container(
                      width: 320,
                      height: 40,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        color: Color.fromRGBO(9, 132, 227, 1),
                        onPressed: () async {
                          if (goalKey.currentState.validate()) {
                            sendZipCode(_zip.text);
                            setState(() {});
                          }
                        },
                        child: Text('Join your community',
                            style: TextStyle(color: Colors.white)),
                      )))),
        ],
      ),
    );

    getUserComm();
    if (isNew == null) {
      return Scaffold(
        body: Center(
          child: Container(
            child: Text(
              "Loading...",
              style: TextStyle(fontSize: 36, fontFamily: 'BungeeInline'),
            ),
          ),
        ),
      );
    } else {
      if (isNew) {
        return locationChoose;
      } else {
        return goalPicked;
      }
    }
  }
}
