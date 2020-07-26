import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:humanknit/profile.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  static final _profileKey = GlobalKey<FormState>();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  final TextEditingController _pic = TextEditingController();


  setData(String name, String desc, String pic) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;
    DocumentReference profileDocument = await Firestore.instance.document("users/$uid/data/profileData");
    profileDocument.setData({
      "name": name,
      "desc" : desc,
      "pic" : pic
    }, merge: true);
  }
  
  

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column (
          children: <Widget>[
            AppBar(
              backgroundColor: Colors.black,
              actions: <Widget>[
              ],
            ),
            Form(
              key: _profileKey,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20/692 * height, left: 20/360 * width, right: 20/360 * width),
                      child: TextFormField(
                        controller: _name,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter a name";
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
                  )
            )),
                  Container(
                      child: Padding(
                          padding: EdgeInsets.only(top: 20/692 * height, left: 20/360 * width, right: 20/360 * width),
                          child: TextFormField(
                              controller: _desc,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please tell us about yourself";
                                }
                                if (value.length > 140) {
                                  int len = value.length;
                                  return "You used $len characters! The maximum is 140.";
                                }
                                return null;
                              },
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              decoration: InputDecoration(
                                errorStyle: TextStyle(fontSize: 8),
                                contentPadding: EdgeInsets.only(top: 4/692 * height, bottom: 4/692 * height, left: 15/360 * width),
                                hintText: "Description",
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
                          )
                      )),
                  Container(
                      child: Padding(
                          padding: EdgeInsets.only(top: 20/692 * height, left: 20/360 * width, right: 20/360 * width),
                          child: TextFormField(
                              controller: _pic,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please enter an image URL";
                                }
                                if (Uri.parse(value).isAbsolute == false) {
                                  return "Please enter a valid image URL";
                                }
                                return null;
                              },
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              decoration: InputDecoration(
                                errorStyle: TextStyle(fontSize: 8),
                                contentPadding: EdgeInsets.only(top: 4/692 * height, bottom: 4/692 * height, left: 15/360 * width),
                                hintText: "Profile Image URL",
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
                          )
                      )),
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40/692 * height, left: 40/360 * width, right: 40/360 * width),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                          side: BorderSide(color: Colors.grey)),
                      color: Color.fromRGBO(252, 186, 3, 1),
                      onPressed: () {
                        if (_profileKey.currentState.validate()) {
                          setData(_name.text, _desc.text, _pic.text);
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text('Change Profile',
                      style:
                      TextStyle(fontSize: 20, color: Colors.white))
                    ),
                  )
                )],
              ),
            )
          ],
        )
      )
    );
  }
}
