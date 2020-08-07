import 'package:flutter/material.dart';
import 'package:humanknit/theme.dart';

class StatsPage extends StatelessWidget {
  //placeholder values: later get from backend
  var numVoted = 4;
  var numVotedPlaces = 2;
  var numVolunteer = 10;
  var numVolunteerPlaces = 7;
  var numAchievements = 6;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        getTextWidget("Voted", 36, AppTheme.THEME_COLORS[0][2], screenHeight),
        getStatRow(numVoted, "Times", screenHeight),
        getStatRow(numVotedPlaces, "Places", screenHeight),
        getTextWidget("Volunteered", 36, AppTheme.THEME_COLORS[0][2], screenHeight),
        getStatRow(numVolunteer, "Times", screenHeight),
        getStatRow(numVolunteerPlaces, "Times", screenHeight),
        getTextWidget("Achievements", 36, AppTheme.THEME_COLORS[0][2], screenHeight),
        getStatRow(numAchievements, "Completed", screenHeight)
      ],
    );
  }

  Row getStatRow(int num, String text, double screenHeight) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getTextWidget(num.toString(), 30, AppTheme.THEME_COLORS[0][3], screenHeight),
          SizedBox(width: 10),
          getTextWidget(text, 24, AppTheme.THEME_COLORS[0][1], screenHeight),
        ]
    );
  }

  Text getTextWidget(String text, double fontSize, Color color, double screenHeight) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize/896 * screenHeight,
        color: color,
      ),
    );
  }
}