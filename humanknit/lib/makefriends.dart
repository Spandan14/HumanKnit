import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MakeFriendsPage extends StatefulWidget {
  @override
  _MakeFriendsPageState createState() => _MakeFriendsPageState();
}

class _MakeFriendsPageState extends State<MakeFriendsPage> {

  static final _pageKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();


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
              actions: <Widget>[
              ],
            ),
            Form(
              key: _pageKey,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20/692 * height, left: 20/360 * width, right: 20/360 * width),
                    child: TextFormField(
                      controller: _username,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter a username";
                        }
                        return null;
                      },
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        decoration: InputDecoration(
                          errorStyle: TextStyle(fontSize: 8),
                          contentPadding: EdgeInsets.only(top: 4/692 * height, bottom: 4/692 * height, left: 15/360 * width),
                          hintText: "Name",
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(100.0),
                            ),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(177, 177, 177, 1),
                              width: 0.5,
                            ),
                          ),
                        )
                    ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
