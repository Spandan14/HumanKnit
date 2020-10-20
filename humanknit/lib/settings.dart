import 'package:flutter/material.dart';
import 'package:humanknit/changepassword.dart';
import 'package:humanknit/customexpansiontile.dart' as custom;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:humanknit/forgotpassword.dart';
import 'package:humanknit/splash.dart';
import 'package:humanknit/startersplash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsPageState();
  }
}

class SettingsPageState extends State<SettingsPage> {

  @override
  Future<void> deleteAccount() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    await user.delete();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final buttonList = Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(),
        Text(
          "Settings",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "PatrickHand",
            fontSize: 48 / 896 * height,
            color: Color(0xffaa767c),
          ),
        ),
        SizedBox(
            //height: 28 / 896 * height,
            ),
        SizedBox(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.only(
                left: 60 / 896 * width, right: 60 / 896 * width),
            child: FlatButton(
              color: Color(0xFFFEEFB3),
              textColor: Color(0xFFAA767C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Color(0xFF875053)),
              ),
              padding: EdgeInsets.only(
                  top: 20 / 896 * height, bottom: 20 / 896 * height),
              child: Text(
                "Disable Account",
                style: TextStyle(
                  fontSize: 24 / height * 896,
                ),
              ),
              onPressed: () {},
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.only(
                left: 60 / 896 * width, right: 60 / 896 * width),
            child: FlatButton(
              color: Color(0xFFFEEFB3),
              textColor: Color(0xFFAA767C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Color(0xFF875053)),
              ),
              padding: EdgeInsets.only(
                  top: 20 / 896 * height, bottom: 20 / 896 * height),
              child: Text(
                "Delete Account",
                style: TextStyle(
                  fontSize: 24 / height * 896,
                ),
              ),
              onPressed: () {
                showDeleteAccountDialog(height);
              },
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.only(
                left: 60 / 896 * width, right: 60 / 896 * width),
            child: FlatButton(
              color: Color(0xFFFEEFB3),
              textColor: Color(0xFFAA767C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Color(0xFF875053)),
              ),
              padding: EdgeInsets.only(
                  top: 20 / 896 * height, bottom: 20 / 896 * height),
              child: Text(
                "Change Password",
                style: TextStyle(
                  fontSize: 24 / height * 896,
                ),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordScreen()));
              },
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Container(
            child: Padding(
              padding: EdgeInsets.only(
                  right: width * 60 / 416, left: width * 60 / 416),
              child: RaisedButton(
                padding: EdgeInsets.only(top: 20 / 896 * height, bottom: 20 / 896 * height),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                    side: BorderSide(color: Colors.grey)),
                color: Color(0xffaa767c),
                onPressed: () {
                  FirebaseAuth.instance
                      .signOut()
                      .then((result) => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen())))
                      .catchError((err) => print(err));
                },
                child: Text('Log Out',
                    style: TextStyle(
                        fontSize: 30 / 896 * height, color: Colors.white)),
              ),
            ),
          ),
        ),
        SizedBox(),
      ],
    );
    /*final logoutButton = Container(
        height: height * 130 / 896,
        child: Padding(
            padding: EdgeInsets.only(
                top: height * 50 / 896,
                right: width * 60 / 416,
                left: width * 60 / 416),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                  side: BorderSide(color: Colors.grey)),
              color: AppTheme.THEME_COLORS[3][2],
              onPressed: () {
                FirebaseAuth.instance
                    .signOut()
                    .then((result) => Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen())))
                    .catchError((err) => print(err));
              },
              child: Text('Log Out',
                  style: TextStyle(
                      fontSize: 30 / 896 * height, color: Colors.white)),
            )));*/

    return Center(
      child: buttonList,
    );
  }

  void showDeleteAccountDialog(double height) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(fontFamily: "BungeeInline"),
          child: AlertDialog(
            backgroundColor: Color(0xfffeefb3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            title: Text(
              'Delete Account',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xffb75053),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Are you sure you want to delete your account? You will be redirected to the login page.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xffb75053),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FlatButton(
                      child: Text(
                        'Yes',
                        style: TextStyle(
                          color: Color(0xffaa767c),
                        ),
                      ),
                      onPressed: () {
                        deleteAccount();
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                    ),
                    FlatButton(
                      child: Text(
                        'No',
                        style: TextStyle(
                          color: Color(0xffaa767c),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


}
