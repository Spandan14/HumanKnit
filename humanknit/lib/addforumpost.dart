import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:humanknit/profile.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:typed_data';

class ForumAdd extends StatefulWidget {
  final String goalUID;

  ForumAdd({Key key, @required this.goalUID}) : super(key: key);
  @override
  _ForumAddState createState() => _ForumAddState();
}

class _ForumAddState extends State<ForumAdd> {
  static final _formkeyForum = GlobalKey<FormState>();

  final TextEditingController _forum = TextEditingController();

  Future<void> addForum(String forumText) async {
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
    DocumentReference forumDoc = await Firestore.instance.document(
        "communities/$community/goals/$formattedDate/goals/${widget.goalUID}/forumPosts/$id");
    forumDoc.setData({
      'reply': forumText,
    }, merge: true);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: <Widget>[
            AppBar(
              backgroundColor: Colors.black,
            ),
            Form(
              key: _formkeyForum,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        left: 30 / 360 * width,
                        right: 30 / 360 * width,
                        top: 10 / 692 * height),
                    child: Container(
                        child: TextFormField(
                          controller: _forum,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter a reply";
                            }
                            return null;
                          },
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                          ),
                          decoration: InputDecoration(
                              errorStyle: TextStyle(fontSize: 8),
                              contentPadding: const EdgeInsets.only(
                                  top: 4, bottom: 4, left: 15),
                              hintText: "Reply Text",
                              border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(100.0),
                                  ),
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(177, 177, 177, 1),
                                    width: 0.5,
                                  ))),
                        )),
                  ),
                  Container(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 10 / 692 * height,
                            left: 40 / 360 * width,
                            right: 40 / 360 * width),
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                                side: BorderSide(color: Colors.grey)),
                            color: Color.fromRGBO(252, 186, 3, 1),
                            onPressed: () {
                              if (_formkeyForum.currentState.validate()) {
                                addForum(_forum.text);
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text('Add Reply',
                                style:
                                TextStyle(fontSize: 20, color: Colors.white))),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
