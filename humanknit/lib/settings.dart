import 'package:flutter/material.dart';
import 'package:humanknit/customexpansiontile.dart' as custom;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
                  ),
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
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Theme(
                        data: ThemeData(fontFamily: "BungeeInline"),
                        child: AlertDialog(
                          backgroundColor: Color(0xfffeefb3),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  FlatButton(
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(
                                        color: Color(0xff875053),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
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
                          /*actions: [
                            // button 2
                            FlatButton(
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                  color: Color(0xff875053),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
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
                          ],*/
                        ),
                      );
                    },
                  );
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
        height: height * 130/896,
        child: Padding (
          padding: EdgeInsets.only(top: height * 50/896, right: width * 60/416, left: width * 60/416),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                  side: BorderSide(color: Colors.grey)),
              color: Color(0xffaa767c),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((result) => Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => LoginScreen()
                ))).catchError((err) => print(err));
              },
              child: Text('Log Out',
                  style:
                  TextStyle(fontSize: 20, color: Colors.white)
              ),
            )
        )
    );

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
