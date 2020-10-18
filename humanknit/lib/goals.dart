import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:humanknit/addgoal.dart';
import 'package:humanknit/editprofile.dart';
import 'package:humanknit/friendsview.dart';
import 'package:humanknit/makefriends.dart';
import 'package:humanknit/stats.dart';
import 'package:intl/intl.dart';
import 'addpost.dart';

class GoalsPage extends StatefulWidget {
  @override
  _GoalsPageState createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {

  static ScrollController _scrollController = new ScrollController();
  List<String> _goals = List<String>();
  List<bool> _hasUserVoted = List<bool>();
  List<String> _goalUIDS = List<String>();
  bool loading = true;
  bool canVote = true;

  Future<void>fetchData() async {
    List<String> goals = List<String>();
    List<bool> hasUserVoted = List<bool>();
    List<String> goalUIDS = List<String>();
    setState(() {
      loading = true;
    });
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;
    DocumentReference userDoc = await Firestore.instance.document("users/$uid");
    var community;
    await userDoc.get().then((datasnapshot) async {
      community = await datasnapshot.data['community'];
    });
    var now = DateTime.now();
    var formatter = new DateFormat('yyyy-MMMM');
    String formattedDate = formatter.format(now);
    QuerySnapshot goalDocs = await Firestore.instance.collection("communities/$community/goals/$formattedDate/goals").getDocuments();
    List<DocumentSnapshot> goalDocSnapshots = await goalDocs.documents;
    if (goalDocSnapshots.length == 0) {
      await addGoals();
    }
    for (var snapshot in goalDocSnapshots) {
      await goals.add(snapshot.data['goal']);
      var id = await snapshot.documentID;
      goalUIDS.add(id);
      QuerySnapshot usersVoted = await Firestore.instance.collection("communities/$community/goals/$formattedDate/goals/$id/votes").getDocuments();
      List<DocumentSnapshot> voteDocs = await usersVoted.documents;
      bool isVoted = false;
      for (var votesnapshot in voteDocs) {
          if (votesnapshot.documentID == uid)
            isVoted = true;
      }
      hasUserVoted.add(isVoted);
    }
    setState(() {
      loading = false;
      _goals = goals;
      _hasUserVoted = hasUserVoted;
      _goalUIDS = goalUIDS;
      int numVotes = 0;
      for (var vote in hasUserVoted) {
        if (vote)
          numVotes++;
      }
      canVote = numVotes >= 2 ? false : true;
      firstLoad = false;
    });
  }

  Future<void>addGoals() async {
    List<String> possibleGoals = ["t", "u", "v", "w", "x", "y"];
    var random = new Random();
    var firstGoal = random.nextInt(6);
    String firstGoalText = possibleGoals[firstGoal];
    possibleGoals.removeAt(firstGoal);
    var secondGoal = random.nextInt(5);
    String secondGoalText = possibleGoals[secondGoal];
    print(firstGoalText);
    print(secondGoalText);


    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;
    DocumentReference userDoc = await Firestore.instance.document("users/$uid");
    var community;
    await userDoc.get().then((datasnapshot) async {
      community = await datasnapshot.data["community"];
    });
    var now = DateTime.now();
    var id = now.millisecondsSinceEpoch;
    var formatter = new DateFormat('yyyy-MMMM');
    String formattedDate = formatter.format(now);
    DocumentReference goalDoc = await Firestore.instance.document("communities/$community/goals/$formattedDate/goals/${id.toString()}");
    goalDoc.setData({
      'goal': firstGoalText,
    }, merge: true);
    id = now.millisecondsSinceEpoch+1000;
    DocumentReference secondGoalDoc = await Firestore.instance.document("communities/$community/goals/$formattedDate/goals/${id.toString()}");
    secondGoalDoc.setData({
      'goal': secondGoalText,
    }, merge: true);
  }

  Future<void>setMonthGoal() async {

  }

  Future<void>revokeVote(String goalUID) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;
    DocumentReference userDoc = await Firestore.instance.document("users/$uid");
    var community;
    await userDoc.get().then((datasnapshot) async {
      community = await datasnapshot.data['community'];
    });

    var now = DateTime.now();
    var formatter = new DateFormat('yyyy-MMMM');
    String formattedDate = formatter.format(now);
    await Firestore.instance.document("communities/$community/goals/$formattedDate/goals/$goalUID/votes/$uid").delete();
    setState(() {
      firstLoad = true;
    });
  }

  Future<void>doVote(String goalUID) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;
    DocumentReference userDoc = await Firestore.instance.document("users/$uid");
    var community;
    await userDoc.get().then((datasnapshot) async {
      community = await datasnapshot.data['community'];
    });

    var now = DateTime.now();
    var formatter = new DateFormat('yyyy-MMMM');
    String formattedDate = formatter.format(now);
    await Firestore.instance.document("communities/$community/goals/$formattedDate/goals/$goalUID/votes/$uid").setData({
      'user': uid,
    }, merge: true);
    setState(() {
      firstLoad = true;
    });
  }

  getGoalCard(int position) {
    print("goaltile");
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String goalText, goalUID;
    bool hasVoted;
    goalText = _goals[position];
    goalUID = _goalUIDS[position];
    hasVoted = _hasUserVoted[position];
    return Center(
      child: Container(
        child: GestureDetector(
          onTap: () {
            if (canVote) {
              if (hasVoted) {
                revokeVote(goalUID);
              }
              else {
                doVote(goalUID);
              }
            }
            else {
              if (hasVoted) {
                revokeVote(goalUID);
              }
              else {
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
                            'Cannot Vote',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xff875053),
                            ),
                          ),
                          content: Column (
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                "You have already voted for two goals! Click on them to revoke the votes in order to free up more votes.",
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
                                        'OK',
                                        style: TextStyle(
                                          color: Color(0xff875053),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
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
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Card(
              color: hasVoted ? Color.fromRGBO(116, 185, 255, 1) : Color.fromRGBO(253, 203, 110, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(500)
              ),
              elevation: 2,
              shadowColor: Colors.black,
                child: Container(
                  height: 80,
                  width: 310,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(500),
                  ),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: 70,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                width: 70,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle
                                ),
                              ),
                              Visibility(
                                visible: hasVoted,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.check,
                                    size: 60,
                                  ),
                                ),
                              )
                            ],
                          )
                        ),
                      ),
                      Container(
                        width: 200,
                        child: Text(
                          goalText,
                          style: TextStyle(
                            fontFamily: "PatrickHand",
                            fontSize: 20
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ),
          ),
        ),
    );
  }



  Future<bool>sendZipCode(String zipcode) async {
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
      }
      else {
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

  bool firstLoad = true;

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
              height: 60,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Goals for Next Month",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "PatrickHand",
                      fontSize: 40,
                      color: Color.fromRGBO(0, 206, 201, 1)),
                ),
              ),
            ),
          ),
          Stack(
            children: <Widget>[
              Container(
                height: 500,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          controller: _scrollController,
                          shrinkWrap: true,
                          itemCount: _goalUIDS.length,
                          itemBuilder: (BuildContext context, index) {
                            return getGoalCard(index);
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 100,
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 230,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => GoalAdd()));
                            },
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.centerRight,
                                  width: 100,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color.fromRGBO(162, 155, 254, 1),
                                            Color.fromRGBO(108, 92, 231, 1)
                                          ]
                                      )
                                  ),
                                  width: 100,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.add,
                                    size: 80,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
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
        var now = DateTime.now();
        var formatter = new DateFormat('dd');
        String formattedDate = formatter.format(now);
        int day = int.parse(formattedDate);
        // if (day >= 24) {return goalVoting;}
        // return goalPicked;
        if (firstLoad) {
          fetchData();
        }
        if (loading) {
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
        }
        return goalVoting;
      }
    }
  }
}
