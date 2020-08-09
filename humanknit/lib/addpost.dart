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

class PostAdd extends StatefulWidget {
  @override
  _PostAddState createState() => _PostAddState();
}

class _PostAddState extends State<PostAdd> {
  var _postImage;
  String _uploadedFileURL = "";
  DateTime selectedDate = DateTime.now();
  String _selectedType;
  bool imageVis = false;
  static final _postKey = GlobalKey<FormState>();

  final TextEditingController _caption = TextEditingController();
  final TextEditingController _location = TextEditingController();

  Future chooseImage() async {
    var _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _postImage = _image;
    });
    uploadFile();
  }

  Future uploadFile() async {
    if (_postImage == null) {
      return null;
    }
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;
    StorageReference storageReference = FirebaseStorage.instance.ref().child('$uid/profile/${Path.basename(_postImage.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(_postImage);
    await uploadTask.onComplete.then((value) {setState(() {

    });});
    print('image uploaded');
    storageReference.getDownloadURL().then((fileUrl) {
      setState(() {
        _uploadedFileURL = fileUrl;
        imageVis = true;
      });
    });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(2010, 7), lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  setData() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;
    var id = new DateTime.now().millisecondsSinceEpoch;
    print(_selectedType);
    await Firestore.instance.document("users/$uid/data/postsData").setData({"exists": true}, merge: true);
    DocumentReference postDoc = Firestore.instance.document("users/$uid/data/postsData/posts/${id.toString()}");
    print(selectedDate);
    await postDoc.setData({
      "date": selectedDate.toString().substring(0, selectedDate.toString().indexOf(' ')),
      "type": _selectedType,
      "caption": _caption.text,
      "pic": _uploadedFileURL,
      "location": _location.text,
      "likes": 0,
      "verifies": 0,
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
              key: _postKey,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 30/360 * width, right: 30/360 * width, top: 20/692 * height),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text("Selected Date: ${DateFormat('MM-dd-yyyy').format(selectedDate)}"),
                          Padding(
                            padding: EdgeInsets.only(top: 10/692 * height),
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  side: BorderSide(color: Colors.grey)),
                              color: Color.fromRGBO(252, 186, 3, 1),
                              onPressed: () {_selectDate(context);},
                                child: Text('Change Date',
                                    style:
                                    TextStyle(fontSize: 12, color: Colors.white))
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30/360 * width, right: 30/360 * width, top: 10/692 * height),
                    child: Container(
                      child: DropdownButtonFormField(
                        validator: (_selectedType) {
                          if (_selectedType == null) {
                            return "Please select an event type";
                          }
                          return null;
                        },
                        hint: Text("Event Type"),
                        value: _selectedType,
                        items: <String>['Volunteering Event', 'Election', 'Community Event'].map((String value) {
                          setState(() {
                            _selectedType = value;
                          });
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        onChanged: (_) {
                        },
                        decoration: InputDecoration(
                          errorStyle: TextStyle(fontSize: 8),
                        ),

                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30/360 * width, right: 30/360 * width, top: 10/692 * height),
                    child: Container(
                        child: TextFormField(
                          controller: _caption,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter a caption";
                            }
                            if (value.length > 140) {
                              return "You used ${value.length} characters! The maximum is 140.";
                            }
                            return null;
                          },
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                          ),
                          decoration: InputDecoration(
                              errorStyle: TextStyle(fontSize: 8),
                              contentPadding:
                              const EdgeInsets.only(top: 4, bottom: 4, left: 15),
                              hintText: "Caption",
                              border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(100.0),
                                  ),
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(177, 177, 177, 1),
                                    width: 0.5,
                                  ))),
                        )
                    ),
                  ),
                  Container(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10/692 * height, left: 20/360 * width, right: 20/360 * width),
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                                side: BorderSide(color: Colors.grey)),
                            color: Color.fromRGBO(252, 186, 3, 1),
                            onPressed: () {
                              chooseImage();
                            },
                            child: Text('Choose Image',
                                style:
                                TextStyle(fontSize: 20, color: Colors.white))
                        ),
                      )),
                  Visibility(
                    visible: imageVis,
                    child: Container(
                      alignment: Alignment.center,
                      height: 200/692 * height,
                      width: 200/360 * width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(_uploadedFileURL), fit: BoxFit.cover),
                          border: Border.all(color: Colors.black, width: 2),
                    ),
                  )
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30/360 * width, right: 30/360 * width, top: 10/692 * height),
                    child: Container(
                        child: TextFormField(
                          controller: _location,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter a location";
                            }
                            return null;
                          },
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                          ),
                          decoration: InputDecoration(
                              errorStyle: TextStyle(fontSize: 8),
                              contentPadding:
                              const EdgeInsets.only(top: 4, bottom: 4, left: 15),
                              hintText: "Event Address",
                              border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(100.0),
                                  ),
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(177, 177, 177, 1),
                                    width: 0.5,
                                  ))),
                        )
                    ),
                  ),
                  Container(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10/692 * height, left: 40/360 * width, right: 40/360 * width),
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                                side: BorderSide(color: Colors.grey)),
                            color: Color.fromRGBO(252, 186, 3, 1),
                            onPressed: () {
                              if (_postKey.currentState.validate()) {
                                setData();
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text('Add Post',
                                style:
                                TextStyle(fontSize: 20, color: Colors.white))
                        ),
                      )
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
