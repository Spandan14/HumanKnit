import "package:flutter/material.dart";

class ExperiencesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final pageTitle = Text(
      "Events & Experiences",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 48 / 896 * screenHeight,
        color: Color(0xff7348a6),
      ),
    );

    final volunteeringButton =
        makeButton("Volunteering", "Lend a helping hand", screenHeight);
    final votingButton =
        makeButton("Voting", "Make your voice heard", screenHeight);
    final communityButton =
        makeButton("Community Events", "Enjoy the fun!", screenHeight);

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

  FlatButton makeButton(String title, String description, double screenHeight) {
    return FlatButton(
      color: Color(0xff35c38d),
      padding: EdgeInsets.all(20),
      onPressed: () {},
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 30 / 896 * screenHeight,
              color: Color(0xfff25740),
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
