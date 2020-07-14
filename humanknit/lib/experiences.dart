import "package:flutter/material.dart";

class ExperiencesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final iconSize = 30 / 896 * screenHeight;

    final pageTitle = Text(
      "Events & Experiences",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 48 / 896 * screenHeight,
      ),
    );
    print(screenHeight);

    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            pageTitle,
            makeButton("Volunteering", "Lend a helping hand", screenHeight),
            makeButton("Voting", "Make your voice heard", screenHeight),
            makeButton("Community Events", "Enjoy the fun!", screenHeight),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: Color(0xffffb86f),
          items: [
            BottomNavigationBarItem(
              icon: ImageIcon(
                new AssetImage("assets/images/profile.png"),
                size: iconSize,
              ),
              title: Text(""),
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                new AssetImage("assets/images/friends.png"),
                size: iconSize,
              ),
              title: Text(""),
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                new AssetImage("assets/images/experiences.png"),
                size: iconSize,
              ),
              title: Text(""),
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                new AssetImage("assets/images/settings.png"),
                size: iconSize,
              ),
              title: Text(""),
            ),
          ],
        ),
      ),
    );
  }

  FlatButton makeButton(String title, String description, double screenHeight) {
    return FlatButton(
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 30/896 * screenHeight,
            ),
          ),
          Text(
            description,
            style: TextStyle(
              fontSize: 20/896 * screenHeight,
            ),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
  }
}
