import 'package:flutter/material.dart';
import 'package:humanknit/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  var _numVoted, _numEvents, _numVolunteer, _numCommunity, _numAchievements;
  fetchData() async {
    var numVoted = 0, numEvents = 0, numVolunteer = 0, numCommunity = 0;
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uid = await user.uid;
    QuerySnapshot events = await Firestore.instance.collection("users/$uid/data/postsData/posts").getDocuments();
    List<DocumentSnapshot> eventsDocs = await events.documents;
    await eventsDocs.forEach((eventsnapshot) async {
      numEvents++;
      switch (eventsnapshot.data["type"]) {
        case "Volunteering Event":
          numVolunteer++;
          break;
        case "Community Event":
          numCommunity++;
          break;
        case "Election":
          numVoted++;
          break;
        default:
          break;
      }

    });
    setState(() {
      _numVoted = numVoted;
      _numCommunity = numCommunity;
      _numVolunteer = numVolunteer;
      _numEvents = numEvents;
    });
  }
  
  bool first = true;
  @override
  Widget build(BuildContext context) {
    if (first) {
      fetchData();
      first = false;
    }
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(

        children: [
          AppBar(
            backgroundColor: Colors.black,
            actions: <Widget>[],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(height: 8,),
              getTextWidget("Voted", 36, AppTheme.THEME_COLORS[0][2], screenHeight),
              getStatRow(_numVoted, "Times", screenHeight),
              getTextWidget("Volunteered", 36, AppTheme.THEME_COLORS[0][2], screenHeight),
              getStatRow(_numVolunteer, "Times", screenHeight),
              getTextWidget("Went to Community Events", 30, AppTheme.THEME_COLORS[0][2], screenHeight),
              getStatRow(_numCommunity, "Times", screenHeight),
              getTextWidget("Total Events", 36, AppTheme.THEME_COLORS[0][2], screenHeight),
              getStatRow(_numEvents, "Events", screenHeight),
              Container(height: 20,),
              getTextWidget("Badges", 36, AppTheme.THEME_COLORS[0][2], screenHeight),
              Container(
                height: 300/692 * screenHeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GridView.count(
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    crossAxisCount: 5,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Center(
                            child: Image.asset("assets/Badges/IdentifyYourself.png"),
                          ),
                          Container(
                            color: Color.fromRGBO(255, 255, 255, 0),
                          ),
                        ]
                      ),
                      Stack(
                          children: <Widget>[
                            Center(
                              child: Image.asset("assets/Badges/Hi-There.png"),
                            ),
                            Container(
                              color: Color.fromRGBO(255, 255, 255, 0),
                            ),
                          ]
                      ),
                      Stack(
                          children: <Widget>[
                            Center(
                              child: Image.asset("assets/Badges/FirstTime.png"),
                            ),
                            Container(
                              color: Color.fromRGBO(255, 255, 255, 0),
                            ),
                          ]
                      ),
                      Stack(
                          children: <Widget>[
                            Center(
                              child: Image.asset("assets/Badges/Verified1.png"),
                            ),
                            Container(
                              color: Color.fromRGBO(255, 255, 255, 0.69),
                            ),
                          ]
                      ),
                      Stack(
                          children: <Widget>[
                            Center(
                              child: Image.asset("assets/Badges/Voted.png"),
                            ),
                            Container(
                              color: Color.fromRGBO(255, 255, 255, 0.69),
                            ),
                          ]
                      ),
                      Stack(
                          children: <Widget>[
                            Center(
                              child: Image.asset("assets/Badges/4july.png"),
                            ),
                            Container(
                              color: Color.fromRGBO(255, 255, 255, 0.69),
                            ),
                          ]
                      ),
                      Stack(
                          children: <Widget>[
                            Center(
                              child: Image.asset("assets/Badges/Invested.png"),
                            ),
                            Container(
                              color: Color.fromRGBO(255, 255, 255, 0.69),
                            ),
                          ]
                      ),
                      Stack(
                          children: <Widget>[
                            Center(
                              child: Image.asset("assets/Badges/Verified2.png"),
                            ),
                            Container(
                              color: Color.fromRGBO(255, 255, 255, 0.69),
                            ),
                          ]
                      ),
                      Stack(
                          children: <Widget>[
                            Center(
                              child: Image.asset("assets/Badges/Socializing.png"),
                            ),
                            Container(
                              color: Color.fromRGBO(255, 255, 255, 0.69),
                            ),
                          ]
                      ),
                      Stack(
                          children: <Widget>[
                            Center(
                              child: Image.asset("assets/Badges/Selfless1.png"),
                            ),
                            Container(
                              color: Color.fromRGBO(255, 255, 255, 0.69),
                            ),
                          ]
                      ),
                      Stack(
                          children: <Widget>[
                            Center(
                              child: Image.asset("assets/Badges/Outgoing.png"),
                            ),
                            Container(
                              color: Color.fromRGBO(255, 255, 255, 0.69),
                            ),
                          ]
                      ),
                      Stack(
                          children: <Widget>[
                            Center(
                              child: Image.asset("assets/Badges/Dedicated.png"),
                            ),
                            Container(
                              color: Color.fromRGBO(255, 255, 255, 0.69),
                            ),
                          ]
                      ),
                      Stack(
                          children: <Widget>[
                            Center(
                              child: Image.asset("assets/Badges/Selfless2.png"),
                            ),
                            Container(
                              color: Color.fromRGBO(255, 255, 255, 0.69),
                            ),
                          ]
                      ),
                      Stack(
                          children: <Widget>[
                            Center(
                              child: Image.asset("assets/Badges/Verified3.png"),
                            ),
                            Container(
                              color: Color.fromRGBO(255, 255, 255, 0.69),
                            ),
                          ]
                      ),
                      Stack(
                          children: <Widget>[
                            Center(
                              child: Image.asset("assets/Badges/PoliticalActive.png"),
                            ),
                            Container(
                              color: Color.fromRGBO(255, 255, 255, 0.69),
                            ),
                          ]
                      ),
                      Stack(
                          children: <Widget>[
                            Center(
                              child: Image.asset("assets/Badges/Selfless3.png"),
                            ),
                            Container(
                              color: Color.fromRGBO(255, 255, 255, 0.69),
                            ),
                          ]
                      ),
                      Stack(
                          children: <Widget>[
                            Center(
                              child: Image.asset("assets/Badges/VerifiedIV.png"),
                            ),
                            Container(
                              color: Color.fromRGBO(255, 255, 255, 0.69),
                            ),
                          ]
                      ),
                      Stack(
                          children: <Widget>[
                            Center(
                              child: Image.asset("assets/Badges/VerifiedV.png"),
                            ),
                            Container(
                              color: Color.fromRGBO(255, 255, 255, 0.69),
                            ),
                          ]
                      ),
                      Stack(
                          children: <Widget>[
                            Center(
                              child: Image.asset("assets/Badges/Scheduler.png"),
                            ),
                            Container(
                              color: Color.fromRGBO(255, 255, 255, 0.69),
                            ),
                          ]
                      ),
                      Stack(
                          children: <Widget>[
                            Center(
                              child: Image.asset("assets/Badges/AnEventADay.png"),
                            ),
                            Container(
                              color: Color.fromRGBO(255, 255, 255, 0.69),
                            ),
                          ]
                      ),

                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Row getStatRow(int num, String text, double screenHeight) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getTextWidget(num.toString(), 30, AppTheme.THEME_COLORS[0][3], screenHeight),
          SizedBox(width: 10),
          getTextWidget(text, 24, AppTheme.THEME_COLORS[0][1], screenHeight),
        ]
    );
  }

  Text getTextWidget(String text, double fontSize, Color color, double screenHeight) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize/896 * screenHeight,
        color: color,
      ),
    );
  }
}
