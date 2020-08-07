import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:humanknit/profile.dart';

class PostAdd extends StatefulWidget {
  @override
  _PostAddState createState() => _PostAddState();
}

class _PostAddState extends State<PostAdd> {
  File _postImage;
  String _uploadedFileURL = "";


  static final _postKey = GlobalKey<FormState>();

  final TextEditingController _caption = TextEditingController();

  Future chooseImage() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _postImage = image;
      });
    });
  }

  Future uploadFile() async {
    if (_postImage == null) {
      return null;
    }
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;
    StorageReference storageReference = FirebaseStorage.instance.ref().child('$uid/profile/${Path.basename(_postImage.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(_postImage);
    await uploadTask.onComplete;
    print('image uploaded');
    storageReference.getDownloadURL().then((fileUrl) {
      setState(() {
        _uploadedFileURL = fileUrl;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
