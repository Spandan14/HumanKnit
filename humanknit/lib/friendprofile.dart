import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:humanknit/editprofile.dart';
import 'package:humanknit/makefriends.dart';

import 'friendspost.dart';

class FriendProfilePage extends StatefulWidget {
  final String friendUID;

  FriendProfilePage({Key key, @required this.friendUID}) : super(key: key);

  @override
  _FriendProfilePageState createState() => _FriendProfilePageState();
}


class _FriendProfilePageState extends State<FriendProfilePage> {

  bool backButtonVisible = false;
  bool settingsHint = false;
  String profileName, profileDesc, profilePic;
  int numFriends, numPosts;

  Future<void>sendFriendRequest() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;
    QuerySnapshot friends = await Firestore.instance.collection("users/${widget.friendUID}/data/friendsData/friends").getDocuments();
    List<DocumentSnapshot> friendsList = await friends.documents;
    List<String> userfriends = List<String>();
    await friendsList.forEach((friend) {
      if (friend.exists) {
        userfriends.add(friend["friend"]);
      }
    });
    DocumentReference request = await Firestore.instance.document("users/${widget.friendUID}/data/friendsData/requests/$uid");
    DocumentReference counterRequest = await Firestore.instance.document("users/$uid/data/friendsData/requests/${widget.friendUID}");
    DocumentSnapshot counter;
    await counterRequest.get().then((datasnapshot) {counter = datasnapshot;});
    request.get().then((datasnapshot) {
      if (datasnapshot.exists) {

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
                      'Friend Request',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xff875053),
                      ),
                    ),
                    content: Column (
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "You have already sent a friend request to this user",
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
      else {
        print("frenz");
        print(userfriends);
        print(uid);
        if (userfriends.contains(uid)) {
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
                      'Friend Request',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xff875053),
                      ),
                    ),
                    content: Column (
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "You are already friends. No need to send a request",
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
        else {
          request.setData({
            "from": uid,
          }, merge: true);
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
                      'Friend Request',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xff875053),
                      ),
                    ),
                    content: Column (
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Friend request has successfully been sent to the user",
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
      });
  }

  Future<void>fetchData() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uid = widget.friendUID;

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
              profileName = "User hasn't set their name";
              settingsHint = true;
            }
            if (datasnapshot.data['desc'] != null) {
              profileDesc = datasnapshot.data['desc'].toString();
            } else {
              profileDesc = "User hasn't set their profile description!";
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


    DocumentReference friendsDocument = await Firestore.instance.document("users/$uid/data/friendsData");
    QuerySnapshot friends = await Firestore.instance.collection("users/$uid/data/friendsData/friends").getDocuments();
    QuerySnapshot requests = await Firestore.instance.collection("users/$uid/data/friendsData/requests").getDocuments();
    List<DocumentSnapshot> friendDocs = friends.documents;
    List<DocumentSnapshot> requestDocs = requests.documents;
    friendsDocument.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        if (numFriends == null) {
          friendsDocument.setData({
            "numFriends": friendDocs.length,
            "numRequests": requestDocs.length,
          }, merge: true);
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
        });
        friendsDocument.setData({
          "numFriends": friendDocs.length,
          "numRequests": requestDocs.length,
        }, merge: true);
        friendsDocument.collection("friends").add({});
        friendsDocument.collection("requests").add({});
      }
    });
    QuerySnapshot postsDocs = await Firestore.instance.collection("users/$uid/data/postsData/posts").getDocuments();
    List<DocumentSnapshot> posts = await postsDocs.documents;
    setState(() {
      numPosts = posts.length;
    });
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
                IconButton(
                  onPressed: () {
                    sendFriendRequest();
                  },
                  icon: Icon(Icons.person_add, color: Colors.white,),
                  tooltip: "Add as Friend",
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
                  Container(
                    height: 75,
                    width: 75,
                    child: Column(
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
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => FriendPostsPage(userUID: widget.friendUID,)));
                    },
                    child: Container(
                      height: 75,
                      width: 75,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            numPosts.toString(),
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
                  )
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
