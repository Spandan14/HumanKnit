import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column (
          children: <Widget>[
            AppBar(
              backgroundColor: Colors.black,
              actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white,),
                  onPressed: () {},
                  tooltip: "Back",
                ),
              ],
            ),
          ],
        )
      )
    );
  }
}
