import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:humanknit/addforumpost.dart';
import 'package:humanknit/addgoal.dart';
import 'package:humanknit/editprofile.dart';
import 'package:humanknit/friendsview.dart';
import 'package:humanknit/makefriends.dart';
import 'package:humanknit/stats.dart';
import 'package:intl/intl.dart';
import 'addpost.dart';

class ForumPage extends StatefulWidget {
  final String goalUID;

  ForumPage({Key key, @required this.goalUID}) : super(key: key);

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {

  List<String>_forumPostTexts = List<String>();
  List<String>_forumPostUIDS = List<String>();
  List<String>_forumPostAuthors = List<String>();
  List<String>_forumPostTimestamps = List<String>();
  bool loading = true;
  bool firstLoad = true;


  Future<void>fetchData() async {
    setState(() {
      loading = true;
    });
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;
    DocumentReference userDoc = await Firestore.instance.document("users/$uid");
    var community = "";
    await userDoc.get().then((datasnapshot) async {
      community = await datasnapshot.data["community"];
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          AppBar(
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ForumAdd(goalUID: widget.goalUID,)));
                },
                icon: Icon(Icons.reply, color: Colors.white,),
                tooltip: "Reply to Forum",
              ),
            ],
            backgroundColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
