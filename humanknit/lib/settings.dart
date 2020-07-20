import 'package:flutter/material.dart';
import 'package:humanknit/customexpansiontile.dart' as custom;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:humanknit/splash.dart';
import 'login.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsPageState();
  }
}

class SettingsPageState extends State<SettingsPage> {
  var selected = [
    [true, false],
    [true, false],
    [true, false],
    [true, false]
  ];

  @override
  Future<void> deleteAccount() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    await user.delete();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final expansionList = Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            child: custom.ExpansionTile(
              iconColor: Color(0xff000000),
              headerBackgroundColor: Color(0xfffbbfca),
              backgroundColor: Color(0xfffeefb3),
              title: Padding(
                padding: EdgeInsets.all(28 / 896 * height),
                child: Text(
                  "Display",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30 / 896 * height,
                    color: Color(0xffaa767c),
                  ),
                ),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: 14 / 896 * height, bottom: 14 / 896 * height),
                  child: FlatButton(
                      child: Text(
                        "Change Theme",
                        style: TextStyle(
                          fontSize: 24 / 896 * height,
                          color: Color(0xffaa767c),
                        ),
                      ),
                      onPressed: () {
                        showChangeThemeDialog(height);
                      }),
                ),
                getRowDivider(),
                Padding(
                  padding: EdgeInsets.only(
                      top: 14 / 896 * height, bottom: 14 / 896 * height),
                  child: FlatButton(
                    child: Text(
                      "Replay Tutorial",
                      style: TextStyle(
                        fontSize: 24 / 896 * height,
                        color: Color(0xffaa767c),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          color: Color(0xff875053),
        ),
        custom.ExpansionTile(
          iconColor: Color(0xff000000),
          headerBackgroundColor: Color(0xfffbbfca),
          backgroundColor: Color(0xfffeefb3),
          title: Padding(
            padding: EdgeInsets.all(28 / 896 * height),
            child: Text(
              "Security",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30 / 896 * height,
                color: Color(0xffaa767c),
              ),
            ),
          ),
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: 14 / 896 * height, bottom: 14 / 896 * height),
              child: FlatButton(
                child: Text(
                  "Change Email",
                  style: TextStyle(
                    fontSize: 24 / 896 * height,
                    color: Color(0xffaa767c),
                  ),
                ),
              ),
            ),
            getRowDivider(),
            Padding(
              padding: EdgeInsets.only(
                  top: 14 / 896 * height, bottom: 14 / 896 * height),
              child: FlatButton(
                child: Text(
                  "Change Password",
                  style: TextStyle(
                    fontSize: 24 / 896 * height,
                    color: Color(0xffaa767c),
                  ),
                ),
              ),
            ),
            getRowDivider(),
            Padding(
              padding: EdgeInsets.only(
                  top: 14 / 896 * height, bottom: 14 / 896 * height),
              child: FlatButton(
                child: Text(
                  "Delete Account",
                  style: TextStyle(
                    fontSize: 24 / 896 * height,
                    color: Color(0xffaa767c),
                  ),
                ),
                onPressed: () {
                  showDeleteAccountDialog(height);
                },
              ),
            ),
          ],
        ),
        Divider(
          color: Color(0xff875053),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            child: custom.ExpansionTile(
              iconColor: Color(0xff000000),
              headerBackgroundColor: Color(0xfffbbfca),
              backgroundColor: Color(0xfffeefb3),
              title: Padding(
                padding: EdgeInsets.all(28 / 896 * height),
                child: Text(
                  "Privacy",
                  maxLines: 5,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30 / 896 * height,
                    color: Color(0xffaa767c),
                  ),
                ),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: 14 / 896 * height, bottom: 14 / 896 * height),
                  child: makePrivacySettingsRow(
                      "Allow facebook account link for friends", height, 0),
                ),
                getRowDivider(),
                Padding(
                  padding: EdgeInsets.only(
                      top: 14 / 896 * height, bottom: 14 / 896 * height),
                  child: makePrivacySettingsRow(
                      "Allow chat with friends", height, 1),
                ),
                getRowDivider(),
                Padding(
                  padding: EdgeInsets.only(
                      top: 14 / 896 * height, bottom: 14 / 896 * height),
                  child: makePrivacySettingsRow(
                      "Allow humanknit to use your location", height, 2),
                ),
                getRowDivider(),
                Padding(
                  padding: EdgeInsets.only(
                      top: 14 / 896 * height, bottom: 14 / 896 * height),
                  child: makePrivacySettingsRow(
                      "Allow humanknit to use facebook data", height, 3),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    final logoutButton = Container(
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
              color: Color(0xffaa767c),
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
            )));

    return Center(
      child: ListView(
        children: [
          Text(
            "Settings",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 48 / 896 * height,
              color: Color(0xff875053),
            ),
          ),
          SizedBox(
            height: 28 / 896 * height,
          ),
          expansionList,
          logoutButton
        ],
      ),
    );
  }

  void showChangeThemeDialog(double height) {
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
              'Change Theme',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff875053),
              ),
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Profile Page",
                ),
                makeThemeRow(Color(0xffc9ffc9), Color(0xff99c2a2),
                    Color(0xff93b1a7), Color(0xff71918d), height),
                Text(
                  "Friends Page",
                ),
                makeThemeRow(Color(0xffc1baff), Color(0xffa2d6f9),
                    Color(0xff6c7bff), Color(0xfff25740), height),
                Text(
                  "Community Page",
                ),
                makeThemeRow(Color(0xffc3d1ff), Color(0xff35ce8d),
                    Color(0xfff25740), Color(0xff7348a6), height),
                Text(
                  "Settings Page",
                ),
                makeThemeRow(Color(0xfffeefb3), Color(0xfffbbfca),
                    Color(0xffaa767c), Color(0xff875053), height),
                FlatButton(
                  child: Text(
                    "Done",
                    style: TextStyle(
                      color: Color(0xff875053),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Padding makeThemeRow(Color c1, Color c2, Color c3, Color c4, double height) {
    final circleDiameter = 30 / 896 * height;
    Row colorRow() {
      return Row(
        children: [
          Container(
            width: circleDiameter,
            height: circleDiameter,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: c1,
                border: Border.all(color: Colors.black)),
          ),
          SizedBox(width: circleDiameter / 2),
          Container(
            width: circleDiameter,
            height: circleDiameter,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: c2,
                border: Border.all(color: Colors.black)),
          ),
          SizedBox(width: circleDiameter / 2),
          Container(
            width: circleDiameter,
            height: circleDiameter,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: c3,
                border: Border.all(color: Colors.black)),
          ),
          SizedBox(width: circleDiameter / 2),
          Container(
            width: circleDiameter,
            height: circleDiameter,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: c4,
                border: Border.all(color: Colors.black)),
          ),
        ],
      );
    }

    final row = colorRow();
    return Padding(
      padding:
          EdgeInsets.only(top: 10 / 896 * height, bottom: 40 / 896 * height),
      child: DropdownButton<Row>(
        value: row,
        //icon: Icon(Icons.arrow_drop_down_circle),
        iconSize: 24,
        elevation: 200,
        onChanged: (Row newValue) {
          setState(() {});
        },
        items: [
          DropdownMenuItem<Row>(
            value: row,
            child: row,
          ),
        ],
      ),
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
                color: Color(0xff875053),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Are you sure you want to delete your account? You will be redirected to the login page.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xffaa767c),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FlatButton(
                      child: Text(
                        'Yes',
                        style: TextStyle(
                          color: Color(0xff875053),
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
                          color: Color(0xff875053),
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

  void onTogglePressed(int index, int row) {
    for (int i = 0; i < selected[row].length; i++) {
      this.selected[row][i] = i == index;
    }
  }

  Divider getRowDivider() {
    return Divider(
      color: Color(0xff875053),
      thickness: 2,
    );
  }

  Row makePrivacySettingsRow(String text, double height, int rowIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          flex: 2,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18 / 896 * height,
              color: Color(0xffaa767c),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: ToggleButtons(
            isSelected: selected[rowIndex],
            onPressed: (int index) {
              setState(() {
                onTogglePressed(index, rowIndex);
              });
            },
            selectedColor: Color(0xffffffff),
            fillColor: Color(0xfffbbfca),
            borderColor: Color(0xff875053),
            selectedBorderColor: Color(0xff875053),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            children: [
              Text(
                "Y",
                style: TextStyle(
                  fontSize: 18 / 896 * height,
                ),
              ),
              Text(
                "N",
                style: TextStyle(
                  fontSize: 18 / 896 * height,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
