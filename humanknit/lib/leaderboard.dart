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
import 'friendprofile.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {

  static ScrollController _scrollController = new ScrollController();

  static List<String> _userPics = List<String>();
  static List<String> _userNames = List<String>();
  static List<int> _userLikes = List<int>();
  static List<String> _userUIDS = List<String>();
  static List<int> _userRanks = List<int>();
  bool firstLoad = true;

  Future<void>fetchData(String dropdownValue) async {
    List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October',
    'November', 'December'];
    int month = months.indexOf(dropdownValue)+1;
    print(month);
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;
    List<String> userPics = List<String>();
    List<String> userNames = List<String>();
    List<int> userLikes = List<int>();
    List<String> userUIDS = List<String>();
    List<int> userRanks = List<int>();

    DocumentReference userData = await Firestore.instance.document("users/$uid");
    var community;
    await userData.get().then((datasnapshot) async {
      community = await datasnapshot.data['community'];
    });
    QuerySnapshot commUsers = await Firestore.instance.collection("communities/$community/users").getDocuments();
    List<DocumentSnapshot> commUserDocs = await commUsers.documents;
    await commUserDocs.forEach((datasnapshot) async {
      var tempUID = await datasnapshot.data['user'];
      await userUIDS.add(tempUID);
    });
    await commUserDocs.forEach((datasnapshot) async {
      var tempLikes = await datasnapshot.data[month.toString()];
      if (tempLikes == null) {
        tempLikes = 0;
      }
      await userLikes.add(tempLikes);
      await print(tempLikes);
    });

    List<String>oldUIDS = userUIDS;
    print(oldUIDS);
    print(userLikes);
    userUIDS.sort((a, b) => userLikes[oldUIDS.indexOf(a)].compareTo(userLikes[oldUIDS.indexOf(b)]));
    print(userUIDS);

    await userUIDS.forEach((tempUID) async {
      DocumentReference tempUserDoc = await Firestore.instance.document("users/$tempUID");
      var tempUserName;
      await tempUserDoc.get().then((userdatasnapshot) async {
        tempUserName = await userdatasnapshot.data['name'];
      });
      await userNames.add(tempUserName);

      DocumentReference tempUserProfileDoc = await Firestore.instance.document("users/$tempUID/data/profileData");
      var tempUserPic;
      await tempUserDoc.get().then((userdatasnapshot) async {
        tempUserPic = await userdatasnapshot.data['pic'];
      });
      await userPics.add(tempUserPic);
    });
    print(userNames);

    userLikes.sort();

    userRanks.add(1);
    int tempcounter = 1;
    for (int i = 1; i < userLikes.length; i++) {
      if (userLikes[i] == userLikes[i-1]) {
        tempcounter++;
        userRanks.add(userRanks[i-1]);
      }
      else {
        tempcounter++;
        userRanks.add(tempcounter);
      }
    }
    setState(() {
      firstLoad = false;
      _userUIDS = userUIDS;
      _userLikes = userLikes;
      _userNames = userNames;
      _userPics = userPics;
      _userRanks = userRanks;
    });
  }

  static List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October',
    'November', 'December'];
  static var now = new DateTime.now();
  String dropdownValue = months[now.month-1];

  getRankCard(int position) {
    print('ranktile');
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String uid, name, pic;
    int likes, rank;
    uid = _userUIDS[position];
    likes = _userLikes[position];
    name = _userNames[position];
    pic = _userPics[position];
    rank = _userRanks[position];

    return Center(
      child: Container(
        child: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => FriendProfilePage(friendUID: uid,)));
          },
          child: Card(
            child: Container(
              height: 100,
              width: 320,
              child: Row(
                children: <Widget>[
                  Container(
                    width: 80,
                    child: Text(
                      rank.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "AdventPro",
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(pic), fit: BoxFit.cover),
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.all(
                          Radius.circular(500),
                        )),
                  ),
                  Container(
                    width: 80,
                    child: Text(
                      name,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: "AdventPro"
                      ),
                    ),
                  ),
                  Container(
                    width: 80,
                    child: Text(
                      likes.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "AdventPro"
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (firstLoad) {
      fetchData(dropdownValue);
    }

    Scaffold leaderboard = Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: 200/692 * height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(84, 172, 237, 1),
                  Color.fromRGBO(96, 108, 177, 1)
                ],
                tileMode: TileMode.repeated
              )
            ),
            child: Column(
              children: <Widget>[
                Container(
                  height: 100,
                  width: 360,
                  alignment: Alignment.center,
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 180,
                        alignment: Alignment.centerRight,

                        child: DropdownButton<String>(
                          value: dropdownValue,
                          icon: Icon(Icons.arrow_drop_down),
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "AdventPro",
                            fontWeight: FontWeight.bold,
                            fontSize: 24
                          ),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValue = newValue;
                              firstLoad = true;
                            });
                          },
                          items: <String>['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October',
                                          'November', 'December']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      Container(
                        child: Text(
                          "Leaderboard",
                          style: TextStyle(
                            fontFamily: "AdventPro",
                            fontWeight: FontWeight.bold,
                            fontSize: 24
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Rank: 2",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "AdventPro",
                          fontSize: 24
                        ),
                      )
                    ),
                    Container(
                      height: 85,
                      width: 85,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage("http://placekitten.com/200/300"), fit: BoxFit.cover),
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.all(
                            Radius.circular(500),
                          )),
                    ),
                    Container(
                        child: Text(
                          "Likes: 5",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "AdventPro",
                              fontSize: 24
                          ),
                        )
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                SingleChildScrollView(
                  child: Container(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: _userUIDS.length,
                      itemBuilder: (BuildContext context, index) {
                        return getRankCard(index);
                      },
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );

    return leaderboard;
  }
}
