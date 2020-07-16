import 'package:flutter/material.dart';

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
        getTextWidget("Voted", 36, Color(0xff93b1a7), screenHeight),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getTextWidget(numVoted.toString(), 30, Color(0xff71918d), screenHeight),
            SizedBox(width: 10),
            getTextWidget("Times", 24, Color(0xff99c2a2), screenHeight),
          ]
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getTextWidget(numVotedPlaces.toString(), 30, Color(0xff71918d), screenHeight),
              SizedBox(width: 10),
              getTextWidget("Places", 24, Color(0xff99c2a2), screenHeight),
            ]
        ),
        getTextWidget("Volunteered", 36, Color(0xff93b1a7), screenHeight),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getTextWidget(numVolunteer.toString(), 30, Color(0xff71918d), screenHeight),
              SizedBox(width: 10),
              getTextWidget("Times", 24, Color(0xff99c2a2), screenHeight),
            ]
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getTextWidget(numVolunteerPlaces.toString(), 30, Color(0xff71918d), screenHeight),
              SizedBox(width: 10),
              getTextWidget("Places", 24, Color(0xff99c2a2), screenHeight),
            ]
        ),
        getTextWidget("Achievements", 36, Color(0xff93b1a7), screenHeight),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getTextWidget(numAchievements.toString(), 30, Color(0xff71918d), screenHeight),
              SizedBox(width: 10),
              getTextWidget("Completed", 24, Color(0xff99c2a2), screenHeight),
            ]
        )
      ],
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