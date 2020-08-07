import 'package:flutter/material.dart';
import 'package:humanknit/search.dart';
import 'package:humanknit/theme.dart';

class ExperiencesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("DHFLSJHDLFJDFLSD");
    final screenHeight = MediaQuery.of(context).size.height;
    print(screenHeight);
    final pageTitle = Text(
      "Events & Experiences",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 48 / 896 * screenHeight,
        color: AppTheme.THEME_COLORS[2][3],
      ),
    );

    final volunteeringButton =
        makeButton("Volunteering", "Lend a helping hand", screenHeight, EVENT_TYPE.VOLUNTEER, context);
    final votingButton =
        makeButton("Voting", "Make your voice heard", screenHeight, EVENT_TYPE.VOTE, context);
    final communityButton =
        makeButton("Community Events", "Enjoy the fun!", screenHeight, EVENT_TYPE.COMMUNITY, context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          pageTitle,
          dropShadowContainer(volunteeringButton),
          dropShadowContainer(votingButton),
          dropShadowContainer(communityButton),
        ],
      ),
    );
  }

  Container dropShadowContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Color(0xff000000),
            blurRadius: 10,
            offset: Offset(
              0,
              4,
            ),
          ),
        ],
      ),
      child: child,
    );
  }

  void pushSearchPage(EVENT_TYPE t, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SearchPage(t),
      ),
    );
  }

  FlatButton makeButton(String title, String description, double screenHeight, EVENT_TYPE t, BuildContext context) {
    return FlatButton(
      color: AppTheme.THEME_COLORS[2][1],
      padding: EdgeInsets.all(20),
      onPressed: () {
        pushSearchPage(t, context);
      },
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 30 / 896 * screenHeight,
              color: AppTheme.THEME_COLORS[2][2],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            description,
            style: TextStyle(
              fontSize: 20 / 896 * screenHeight,
              color: Color(0xff000000),
            ),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    );
  }
}
