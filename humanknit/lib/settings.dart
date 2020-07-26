import 'package:flutter/material.dart';
import 'package:humanknit/customexpansiontile.dart' as custom;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:humanknit/splash.dart';
import 'package:humanknit/startersplash.dart';
import 'package:humanknit/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsPageState();
  }
}

class SettingsPageState extends State<SettingsPage> {
  List selected = [
    [true, false],
    [true, false],
    [true, false],
    [true, false]
  ];

  List themeSelected = [
    AppTheme.PROFILE_THEMES.indexOf(AppTheme.THEME_COLORS[0]),
    AppTheme.FRIENDS_THEMES.indexOf(AppTheme.THEME_COLORS[1]),
    AppTheme.COMMUNITY_THEMES.indexOf(AppTheme.THEME_COLORS[2]),
    AppTheme.SETTINGS_THEMES.indexOf(AppTheme.THEME_COLORS[3]),
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
            child: getExpansionTile(
              "Display",
              [
                Padding(
                  padding: EdgeInsets.only(
                      top: 14 / 896 * height, bottom: 14 / 896 * height),
                  child: getSettingsButton(
                    "Change Theme",
                    () {
                      showChangeThemeDialog(height);
                    },
                    height,
                  ),
                ),
                getRowDivider(),
                Padding(
                  padding: EdgeInsets.only(
                      top: 14 / 896 * height, bottom: 14 / 896 * height),
                  child: getSettingsButton(
                    "Replay Tutorial",
                    () {},
                    height,
                  ),
                ),
              ],
              height,
            ),
          ),
        ),
        Divider(
          color: AppTheme.THEME_COLORS[3][3],
        ),
        getExpansionTile(
          "Security",
          [
            Padding(
              padding: EdgeInsets.only(
                  top: 14 / 896 * height, bottom: 14 / 896 * height),
              child: getSettingsButton(
                "Change Email",
                () {},
                height,
              ),
            ),
            getRowDivider(),
            Padding(
              padding: EdgeInsets.only(
                  top: 14 / 896 * height, bottom: 14 / 896 * height),
              child: getSettingsButton(
                "Change Password",
                () {},
                height,
              ),
            ),
            getRowDivider(),
            Padding(
              padding: EdgeInsets.only(
                  top: 14 / 896 * height, bottom: 14 / 896 * height),
              child: getSettingsButton(
                "Delete Account",
                () {
                  showDeleteAccountDialog(height);
                },
                height,
              ),
            ),
          ],
          height,
        ),
        Divider(
          color: AppTheme.THEME_COLORS[3][3],
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
            child: getExpansionTile(
              "Privacy",
              [
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
              height,
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
            )));

    return Center(
      child: ListView(
        children: [
          Text(
            "Settings",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 48 / 896 * height,
              color: AppTheme.THEME_COLORS[3][3],
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
            backgroundColor: AppTheme.THEME_COLORS[3][0],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            title: Text(
              'Change Theme',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.THEME_COLORS[3][3],
              ),
            ),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Profile Page",
                    ),
                    makeThemeRow(0, height, setState),
                    Text(
                      "Friends Page",
                    ),
                    makeThemeRow(1, height, setState),
                    Text(
                      "Community Page",
                    ),
                    makeThemeRow(2, height, setState),
                    Text(
                      "Settings Page",
                    ),
                    makeThemeRow(3, height, setState),
                    Text(
                      "If you save, you will be redirected to your profile page.",
                      textAlign: TextAlign.center,
                    ),
                    FlatButton(
                      child: Text(
                        "Save",
                        style: TextStyle(
                          color: AppTheme.THEME_COLORS[3][3],
                        ),
                      ),
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setInt('theme', genThemeValue());
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StartupSplashScreen()));
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  int genThemeValue() {
    int value = 0;
    for (int i = 0; i < themeSelected.length; i++) {
      value += themeSelected[i];
      value <<= 2;
    }
    value >>= 2;

    return value;
  }

  custom.ExpansionTile getExpansionTile(String text, children, double height) {
    return custom.ExpansionTile(
      iconColor: Color(0xff000000),
      headerBackgroundColor: AppTheme.THEME_COLORS[3][1],
      backgroundColor: AppTheme.THEME_COLORS[3][0],
      title: Padding(
        padding: EdgeInsets.all(28 / 896 * height),
        child: Text(
          text,
          maxLines: 5,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30 / 896 * height,
            color: AppTheme.THEME_COLORS[3][2],
          ),
        ),
      ),
      children: children,
    );
  }

  FlatButton getSettingsButton(String text, onPressed, double height) {
    return FlatButton(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 24 / 896 * height,
          color: AppTheme.THEME_COLORS[3][2],
        ),
      ),
      onPressed: onPressed,
    );
  }

  Padding makeThemeRow(int pageIndex, double height, StateSetter setState) {
    final circleDiameter = 30 / 896 * height;

    Container getCircleContainer(Color c) {
      return Container(
        width: circleDiameter,
        height: circleDiameter,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: c,
            border: Border.all(color: Colors.black)),
      );
    }

    Row colorRow(colors) {
      return Row(
        children: [
          getCircleContainer(colors[0]),
          SizedBox(width: circleDiameter / 2),
          getCircleContainer(colors[1]),
          SizedBox(width: circleDiameter / 2),
          getCircleContainer(colors[2]),
          SizedBox(width: circleDiameter / 2),
          getCircleContainer(colors[3]),
        ],
      );
    }

    List<Row> pageThemeRows = List<Row>();
    List<List<Color>> pageThemes = List<List<Color>>();
    switch (pageIndex) {
      case 0:
        pageThemes = AppTheme.PROFILE_THEMES;
        break;
      case 1:
        pageThemes = AppTheme.FRIENDS_THEMES;
        break;
      case 2:
        pageThemes = AppTheme.COMMUNITY_THEMES;
        break;
      case 3:
        pageThemes = AppTheme.SETTINGS_THEMES;
        break;
    }

    for (int i = 0; i < pageThemes.length; i++) {
      pageThemeRows.add(colorRow(pageThemes[i]));
    }

    return Padding(
      padding:
          EdgeInsets.only(top: 10 / 896 * height, bottom: 40 / 896 * height),
      child: DropdownButton<Row>(
        value: pageThemeRows[themeSelected[pageIndex]],
        iconSize: 24,
        elevation: 200,
        onChanged: (Row value) {
          setState(() {
            themeSelected[pageIndex] = pageThemeRows.indexOf(value);
          });
        },
        items: pageThemeRows.map((Row value) {
          return DropdownMenuItem<Row>(
            value: value,
            child: value,
          );
        }).toList(),
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
            backgroundColor: AppTheme.THEME_COLORS[3][0],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            title: Text(
              'Delete Account',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.THEME_COLORS[3][3],
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Are you sure you want to delete your account? You will be redirected to the login page.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.THEME_COLORS[3][2],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FlatButton(
                      child: Text(
                        'Yes',
                        style: TextStyle(
                          color: AppTheme.THEME_COLORS[3][3],
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
                          color: AppTheme.THEME_COLORS[3][3],
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
      color: AppTheme.THEME_COLORS[3][3],
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
              color: AppTheme.THEME_COLORS[3][2],
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
            fillColor: AppTheme.THEME_COLORS[3][1],
            borderColor: AppTheme.THEME_COLORS[3][3],
            selectedBorderColor: AppTheme.THEME_COLORS[3][3],
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
