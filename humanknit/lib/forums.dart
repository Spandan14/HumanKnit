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
import 'package:intl/intl.dart';
import 'addpost.dart';

class ForumPage extends StatefulWidget {
  final String goalUID;

  ForumPage({Key key, @required this.goalUID}) : super(key: key);

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {

  static ScrollController _scrollController = new ScrollController();
  List<String>_forumPostTexts = List<String>();
  List<String>_forumPostAuthors = List<String>();
  List<String>_forumPostTimestamps = List<String>();
  bool loading = true;
  bool firstLoad = true;


  Future<void>fetchData() async {
    setState(() {
      loading = true;
    });

    List<String>forumPostTexts = List<String>();
    List<String>forumPostAuthors = List<String>();
    List<String>forumPostTimestamps = List<String>();

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;
    DocumentReference userDoc = await Firestore.instance.document("users/$uid");
    var community = "";
    await userDoc.get().then((datasnapshot) async {
      community = await datasnapshot.data["community"];
    });
    var now = DateTime.now();
    var formatter = new DateFormat('yyyy-MMMM');
    String formattedDate = formatter.format(now);
    QuerySnapshot forumPosts = await Firestore.instance.collection("communities/$community/goals/$formattedDate/goals/${widget.goalUID}"
        "/forumPosts").getDocuments();
    List<DocumentSnapshot> forumPostDocs = forumPosts.documents;

    for (var snapshot in forumPostDocs) {
      forumPostTimestamps.add(snapshot.documentID);
      forumPostAuthors.add(snapshot.data["author"]);
      forumPostTexts.add(snapshot.data["reply"]);
    }
    setState(() {
      loading = false;
      firstLoad = false;
      _forumPostAuthors = forumPostAuthors;
      _forumPostTexts = forumPostTexts;
      _forumPostTimestamps = forumPostTimestamps;
    });
  }

  getForumCard(int position) {
    print("forumtile");
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String forumText = _forumPostTexts[position];
    String forumAuthor = _forumPostAuthors[position];
    int forumTimestamp = int.parse(_forumPostTimestamps[position]);
    DateTime forumDate = DateTime.fromMillisecondsSinceEpoch(forumTimestamp);
    var format = DateFormat.yMd().add_jm();
    String timestampString = format.format(forumDate);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shadowColor: Colors.grey,
        elevation: 5,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "$forumAuthor\nAt $timestampString\n",
                    style: TextStyle(
                      fontFamily: "AdventPro",
                      fontWeight: FontWeight.bold,
                      fontSize: 24
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    forumText,
                    style: TextStyle(
                      fontFamily: "AdventPro",
                      fontSize: 18
                    ),
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (firstLoad) {
      fetchData();
      firstLoad = false;
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
          SingleChildScrollView(
            child: Container(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: _forumPostTimestamps.length,
                itemBuilder: (BuildContext context, index) {
                  return getForumCard(index);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
