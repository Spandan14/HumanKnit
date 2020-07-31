import 'dart:html';

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

  List<String> _friendUserPFPS = List<String>();
  List<String> _friendUserNames = List<String>();
  List<String> _friendUserUsernames = List<String>();
  List<String> _friendUserUIDS = List<String>();

  Future<void>fetchFriendsData() async {
    setState(() {
      _friendUserPFPS.clear();
      _friendUserUsernames.clear();
      _friendUserNames.clear();
      _friendUserUIDS.clear();
    });
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String uid = user.uid;
    QuerySnapshot friends = await Firestore.instance.collection("users/$uid/data/friendsData/friends").getDocuments();
    List<DocumentSnapshot> friendDocs = friends.documents;
    List<String> friendUserPFPS = List<String>();
    List<String> friendUserNames = List<String>();
    List<String> friendUserUsernames = List<String>();
    List<String> friendUserUIDS = List<String>();
    
  }


  List<String> _requestUserPFPS = List<String>();
  List<String> _requestUserNames = List<String>();
  List<String> _requestUserUsernames = List<String>();
  List<String> _requestUserUIDS = List<String>();

  Future<void>fetchRequestsData() async {
    setState(() {
      _requestUserPFPS.clear();
      _requestUserUsernames.clear();
      _requestUserNames.clear();
      _requestUserUIDS.clear();
    });
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

  Scaffold friends;
  Scaffold requests;
  Scaffold page;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print("friendspage");
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
