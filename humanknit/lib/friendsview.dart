import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:humanknit/friendprofile.dart';

class FriendListPage extends StatefulWidget {
  @override
  _FriendListPageState createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage> {



  static ScrollController _scrollControlFriend = new ScrollController();
  static ScrollController _scrollControlRequest = new ScrollController();

  static List<String> _friendUserPFPS = List<String>();
  static List<String> _friendUserNames = List<String>();
  static List<String> _friendUserUsernames = List<String>();
  static List<String> _friendUserUIDS = List<String>();

  Future<void>fetchFriendsData() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String uid = user.uid;
    QuerySnapshot friends = await Firestore.instance.collection("users/$uid/data/friendsData/friends").getDocuments();
    List<DocumentSnapshot> friendDocs = friends.documents;
    List<String> friendUserPFPS = List<String>();
    List<String> friendUserNames = List<String>();
    List<String> friendUserUsernames = List<String>();
    List<String> friendUserUIDS = List<String>();
    await friendDocs.forEach((friend) {
      String currentfriendUID = friend.data["friend"];
      DocumentReference friendUser = Firestore.instance.document("users/$currentfriendUID/data/profileData");
      DocumentReference friendUserTwo = Firestore.instance.document("users/$currentfriendUID");
      friendUser.get().then((datasnapshot) {
        friendUserPFPS.add(datasnapshot.data["pic"]);
        friendUserNames.add(datasnapshot.data["name"]);
      });
      friendUserTwo.get().then((datasnapshot) {
        friendUserUsernames.add(datasnapshot.data["name"]);
      });
      friendUserUIDS.add(currentfriendUID);
    });
    setState(() {
      _friendUserNames = friendUserNames;
      _friendUserPFPS = friendUserPFPS;
      _friendUserUIDS = friendUserUIDS;
      _friendUserUsernames = friendUserUsernames;
    });
  }


  static List<String> _requestUserPFPS = List<String>();
  static List<String> _requestUserNames = List<String>();
  static List<String> _requestUserUsernames = List<String>();
  static List<String> _requestUserUIDS = List<String>();

  Future<void>fetchRequestsData() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String uid = user.uid;
    QuerySnapshot requests = await Firestore.instance.collection("users/$uid/data/friendsData/requests").getDocuments();
    List<DocumentSnapshot> requestDocs = requests.documents;
    List<String> requestUserPFPS = List<String>();
    List<String> requestUserNames = List<String>();
    List<String> requestUserUsernames = List<String>();
    List<String> requestUserUIDS = List<String>();
    await requestDocs.forEach((request) async {
      String currentUID = request.data["from"];
      DocumentReference requestUser = await Firestore.instance.document("users/$currentUID/data/profileData");
      DocumentReference requestUserTwo = await Firestore.instance.document("users/$currentUID");
      requestUser.get().then((datasnapshot) {
        requestUserPFPS.add(datasnapshot.data["pic"].toString());
        requestUserNames.add(datasnapshot.data["name"]);
      });
      requestUserTwo.get().then((datasnapshot) {
        requestUserUsernames.add(datasnapshot.data["name"]);
      });
      requestUserUIDS.add(currentUID);
    });
    setState(() {
      _requestUserNames = requestUserNames;
      _requestUserPFPS = requestUserPFPS;
      _requestUserUIDS = requestUserUIDS;
      _requestUserUsernames = requestUserUsernames;
    });
  }


  bool buttonVis = true;
  acceptFriend(String requesterUID) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String uid = user.uid;
    DocumentReference request = await Firestore.instance.document("users/$uid/data/friendsData/requests/$requesterUID");
    await request.delete();
    Firestore.instance.document("users/$uid/data/friendsData/friends/$requesterUID}").setData({
      "friend": requesterUID,
    }, merge: true);
    Firestore.instance.document("users/$requesterUID}/data/friendsData/friends/$uid").setData({
      "friend": uid,
    }, merge: true);
    setState(() {
      buttonVis = false;
    });
  }

  rejectFriend(String requesterUID) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String uid = user.uid;
    DocumentReference request = await Firestore.instance.document("users/$uid/data/friendsData/requests/$requesterUID");
    await request.delete();
    setState(() {
      buttonVis = false;
    });
  }

  getTileRequest(int position) {
    print("requesttile");
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String username = _requestUserUsernames[position];
    String name = _requestUserNames[position];
    String pfp = _requestUserPFPS[position];
    String uid = _requestUserUIDS[position];
    return Container(
      child: Card(
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 8/692 * height, horizontal: 6/360 * width),
          leading: Row(
            children: <Widget>[
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(pfp),
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
              Visibility(
                visible: buttonVis,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                      tooltip: "Accept Friend Request",
                      onPressed: () {
                        acceptFriend(uid);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                      tooltip: "Reject Friend Request",
                      onPressed: () {
                        rejectFriend(uid);
                      },
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: !buttonVis,
                child: Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 60,
                ),
              )

            ],
          ),
          title: Text(
            name,
          ),
          subtitle: Text(
            username,
          ),
        ),
      ),
    );
  }




  getTileFriend(int position) {
    print("friendtile");
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String username = _friendUserUsernames[position];
    String name = _friendUserNames[position];
    String pfp = _friendUserPFPS[position];
    String uid = _friendUserUIDS[position];
    return Container(
      child: Card(
        child: ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => FriendProfilePage(friendUID: uid,)));
          },
          contentPadding: EdgeInsets.symmetric(vertical: 8/692 * height, horizontal: 6/360 * width),
          leading: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(pfp),
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
          title: Text(
            name,
          ),
          subtitle: Text(
            username,
          ),
        ),
      ),
    );
  }
  bool first = true;
  List<bool> isSelected = [true, false];
  @override
  Widget build(BuildContext context) {
    if (first) {
      fetchFriendsData();
    }
    if (first) {
      fetchRequestsData();
    }
    first = false;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print("friendspage");

    Scaffold page, friends, requests;
    friends = Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: Column(
          children: <Widget>[
            AppBar(
              backgroundColor: Colors.black,
              actions: <Widget>[
              ],
            ),
            ToggleButtons(
              children: <Widget>[
                Icon(Icons.person_outline),
                Icon(Icons.person_add),
              ],
              onPressed: (int index) {
                setState(() {
                  if (index == 0) {
                    isSelected = [true,false];
                    page = friends;
                  }
                  if (index == 1) {
                    isSelected = [false, true];
                    page = requests;
                  }
                });
              },
              isSelected: isSelected,
            ),
            SingleChildScrollView(
              child: Container(
                height: 430,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  controller: _scrollControlFriend,
                  shrinkWrap: true,
                  itemCount: _friendUserUsernames.length,
                  itemBuilder: (BuildContext context, index) {
                    return(getTileFriend(index));
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );

    requests = Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: Column(
          children: <Widget>[
            AppBar(
              backgroundColor: Colors.black,
              actions: <Widget>[
              ],
            ),
            ToggleButtons(
              children: <Widget>[
                Icon(Icons.person_outline),
                Icon(Icons.person_add),
              ],
              onPressed: (int index) {
                setState(() {
                  if (index == 0) {
                    isSelected = [true,false];
                    page = friends;
                  }
                  if (index == 1) {
                    isSelected = [false, true];
                    page = requests;
                  }
                });
              },
              isSelected: isSelected,
            ),
            SingleChildScrollView(
              child: Container(
                height: 430,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  controller: _scrollControlRequest,
                  shrinkWrap: true,
                  itemCount: _requestUserUsernames.length,
                  itemBuilder: (BuildContext context, index) {
                    print("hi");
                    Container tile = getTileRequest(index);
                    return tile;
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );

    page = friends;


    try {
      return page;
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
