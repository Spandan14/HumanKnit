import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:humanknit/editprofile.dart';
import 'package:humanknit/makefriends.dart';

class MainProfilePage extends StatefulWidget {
  @override
  _MainProfilePageState createState() => _MainProfilePageState();
}


class _MainProfilePageState extends State<MainProfilePage> {


  bool backButtonVisible = false;
  bool settingsHint = false;
  bool requestsHint = false;
  String profileName, profileDesc, profilePic;
  int numFriends;
  int numRequests;

  Future<void>fetchData() async {

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;

    // getting profile data
    DocumentReference profileDocument = await Firestore.instance.document("users/$uid/data/profileData");
    profileDocument.get().then((datasnapshot) {
     print("data yes");
     if (datasnapshot.exists) {
     print(datasnapshot.data['name'].toString());
     if (profileName == null || profileDesc == null || profilePic == null) {
       setState(() {
         if (datasnapshot.data['name'] != null) {
           profileName = datasnapshot.data['name'].toString();
         } else {
           profileName = "Set your name!";
           settingsHint = true;
         }
         if (datasnapshot.data['desc'] != null) {
           profileDesc = datasnapshot.data['desc'].toString();
         } else {
           profileDesc = "Set your profile description!";
           settingsHint = true;
         }
         if (datasnapshot.data['pic'] != null) {
           profilePic = datasnapshot.data['pic'].toString();
         } else {
           profilePic =
           "https://pp.netclipart.com/pp/s/244-2441803_profile-pic-icon-png.png";
           settingsHint = true;
         }
       }
       );
     }
     }
     else {
       print("nodoc");
       setState(() {
         profileName = "Set your name!";
         profileDesc = "Set your profile description!";
         profilePic = "https://pp.netclipart.com/pp/s/244-2441803_profile-pic-icon-png.png";
         settingsHint = true;
       });
     }});

    // getting friends data
    DocumentReference friendsDocument = await Firestore.instance.document("users/$uid/data/friendsData");
    QuerySnapshot friends = await Firestore.instance.collection("users/$uid/data/friendsData/friends").getDocuments();
    QuerySnapshot requests = await Firestore.instance.collection("users/$uid/data/friendsData/requests").getDocuments();
    List<DocumentSnapshot> friendDocs = friends.documents;
    List<DocumentSnapshot> requestDocs = requests.documents;
    friendsDocument.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        if (numFriends == null || numRequests == null) {
          friendsDocument.setData({
            "numFriends": friendDocs.length,
            "numRequests": requestDocs.length,
          }, merge: true);
          if (datasnapshot.data['numRequests'] == null) {
            setState(() {
              numRequests = 0;
            });
          }
          else {

            setState(() {
              numRequests = datasnapshot.data["numRequests"];
              if (numRequests != 0) {
                requestsHint = true;
              }
            });
          }
          if (datasnapshot.data['numFriends'] == null) {
            setState(() {
              numFriends = 0;
            });
          }
          else {
            setState(() {
              numFriends = datasnapshot.data['numFriends'];
            });
          }
        }
      }
      else {
        setState(() {
          numFriends = 0;
          numRequests = 0;
        });
        friendsDocument.setData({
          "numFriends": friendDocs.length,
          "numRequests": requestDocs.length,
        }, merge: true);
      }
    });
    print(requestsHint);
  }

  @override
  Widget build(BuildContext context) {


    fetchData();

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print("returning");
    try {
      return Scaffold(
        body: Column(
          children: <Widget>[
            AppBar(
              actions: <Widget>[
                Visibility(
                  visible: backButtonVisible,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white,),

                    tooltip: "Back",
                  ),
                ),
                IconButton(
                  onPressed: () {Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProfilePage()),
                  );},
                  icon: Stack(
                    children: <Widget>[
                      Icon(Icons.settings, color: Colors.white,),
                      Visibility(
                        visible: settingsHint,
                        child: new Positioned(
                          top: 0.0,
                          right: 0.0,
                          child: Icon(Icons.brightness_1, size: 10, color: Colors.redAccent),
                        ),
                      )
                    ],
                  ),
                  tooltip: "Profile Settings",
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MakeFriendsPage()));
                  },
                  icon: Icon(Icons.search, color: Colors.white,),
                  tooltip: "Make Friends",
                ),
              ],
              backgroundColor: Colors.black,
            ),
            Padding(
              padding: EdgeInsets.only(top: width* 40/692, left: 20/360, right: 20/360),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 75,
                    width: 75,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(profilePic),
                            fit: BoxFit.cover
                        ),
                        border: Border.all(
                            color: Colors.black,
                            width: 2
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(500),
                        )
                    ),
                  ),
                  GestureDetector(
                    onTap: () {

                    },

                    child: Container(
                      height: 75,
                      width: 75,
                      child: Stack(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                numFriends.toString(),
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                              Text(
                                "Friends",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              )

                            ],
                          ),
                          Visibility(
                            visible: requestsHint,
                            child: new Positioned(
                              top: 0.0,
                              right: 0.0,
                              child: Icon(Icons.brightness_1, size: 10, color: Colors.redAccent),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 75,
                    width: 75,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "12",
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          "Posts",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        )

                      ],

                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16/360 * width, top: 20/692 * height),
                  child: Text(
                    profileName,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.left,
                  ),
                )
            ),
            Container(
              alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16/360 * width, top: 20/692 * height, right: 16/360 * width),
                  child: Text(
                    profileDesc,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.left,
                  ),
                )
            )
          ],
        ),
      );
    } catch (e) {
      print(e);
      return Scaffold(
        body: Center(
          child: Container(
            child: Text(
              "Loading...",
              style: TextStyle(
                  fontSize: 36,
                  fontFamily: 'BungeeInline'
              ),
            ),
          ),
        ),
      );
    }
  }
}
