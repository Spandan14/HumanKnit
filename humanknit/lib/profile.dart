import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:humanknit/events.dart';
import 'package:humanknit/stats.dart';
import 'package:humanknit/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> {
  bool isLoading = false;
  var statsEventsSelected = [true, false];
  var selectedIndex = 0;
  var timeSelected = [true, false, false];
  final children = [StatsPage(), EventsPage()];

  String userEmail;

  void fetchData() async {
    setState(() {
      isLoading = true;
    });
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    userEmail = user.email;
    setState(() {
      isLoading = false;
    });
  }

  void initState() {
    super.initState();
    fetchData();
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final nameText = Text(
      userEmail,
      style: TextStyle(
        fontSize: 36 / 896 * screenHeight,
        color: AppTheme.THEME_COLORS[0][3],
      ),
    );

    var statsEventsToggle = ToggleButtons(
      onPressed: (int index) {
        selectedIndex = index;
        setState(() {
          for (int i = 0; i < statsEventsSelected.length; i++) {
            statsEventsSelected[i] = i == index;
          }
        });
      },
      isSelected: statsEventsSelected,
      selectedColor: Color(0xffffffff),
      selectedBorderColor: Color(0xff000000),
      borderColor: Color(0xff000000),
      fillColor: AppTheme.THEME_COLORS[0][3],
      borderWidth: 3,
      borderRadius: BorderRadius.all(
        Radius.circular(20),
      ),
      children: [
        wrapInPaddingContainer(
          Text(
            "Stats",
            style: TextStyle(
              fontSize: 38 / 896 * screenHeight,
            ),
          ),
        ),
        wrapInPaddingContainer(
          Text(
            "Events",
            style: TextStyle(
              fontSize: 38 / 896 * screenHeight,
            ),
          ),
        ),
      ],
    );

    final timeToggle = ToggleButtons(
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < timeSelected.length; i++) {
            timeSelected[i] = i == index;
          }
        });
      },
      isSelected: timeSelected,
      selectedColor: AppTheme.THEME_COLORS[0][1].withAlpha(0x80000000),
      selectedBorderColor: AppTheme.THEME_COLORS[0][2],
      borderColor: AppTheme.THEME_COLORS[0][2],
      borderWidth: 1,
      borderRadius: BorderRadius.all(
        Radius.circular(20),
      ),
      children: [
        wrapInPaddingContainer(
          Text(
            "All time",
            style: TextStyle(
              fontSize: 14 / 896 * screenHeight,
              color: AppTheme.THEME_COLORS[0][3],
            ),
          ),
        ),
        wrapInPaddingContainer(
          Text(
            "Year",
            style: TextStyle(
              fontSize: 14 / 896 * screenHeight,
              color: AppTheme.THEME_COLORS[0][3],
            ),
          ),
        ),
        wrapInPaddingContainer(
          Text(
            "Month",
            style: TextStyle(
              fontSize: 14 / 896 * screenHeight,
              color: AppTheme.THEME_COLORS[0][3],
            ),
          ),
        ),
      ],
    );

    return isLoading ? Center(child: CircularProgressIndicator(),)
    :Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        new Flexible(
          fit: FlexFit.tight,
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              nameText,
              statsEventsToggle,
              timeToggle,
            ],
          ),
        ),
        new Flexible(
          fit: FlexFit.tight,
          flex: 2,
          child: children[selectedIndex],
        ),
      ],
    );
  }

  Container wrapInPaddingContainer(Widget w) {
    return Container(
      padding: EdgeInsets.all(10),
      child: w,
    );
  }
}
