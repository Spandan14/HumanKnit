import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:humanknit/profile.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File _pfpImage;
  String _uploadedFileURL = "";

  Future chooseImage() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _pfpImage = image;
      });
    });
  }

  Future uploadFile() async {
    if (_pfpImage == null) {
      return null;
    }
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;
    StorageReference storageReference = FirebaseStorage.instance.ref().child('$uid/profile/${Path.basename(_pfpImage.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(_pfpImage);
    await uploadTask.onComplete;
    print('image uploaded');
    storageReference.getDownloadURL().then((fileUrl) {
      setState(() {
        _uploadedFileURL = fileUrl;
      });
    });
  }


  static final _profileKey = GlobalKey<FormState>();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  final TextEditingController _pic = TextEditingController();


  setData(String name, String desc, String pic) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;
    DocumentReference profileDocument = await Firestore.instance.document("users/$uid/data/profileData");
    if (name != "")
        profileDocument.setData({"name":name}, merge: true);
    if (desc != "")
      profileDocument.setData({"desc":desc}, merge: true);
    if (_uploadedFileURL != "")
      profileDocument.setData({"pic":_uploadedFileURL}, merge: true);
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
                                if (value.length > 140 && !value.isEmpty) {
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
                  Container(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20/692 * height, left: 20/360 * width, right: 20/360 * width),
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                                side: BorderSide(color: Colors.grey)),
                            color: Color.fromRGBO(252, 186, 3, 1),
                            onPressed: () {
                              uploadFile();
                            },
                            child: Text('Set Image as Profile Picture',
                                style:
                                TextStyle(fontSize: 12, color: Colors.white))
                        ),
                      )),
                Padding(
                  padding: EdgeInsets.only(left: 40/360 * width, right: 40/360 * width, top: 40/692 * height),
                  child: Container(
                      width: 360,
                      child: Text(
                        'Please be patient for our servers to update your information, as this may take a minute',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      )),
                ),
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
