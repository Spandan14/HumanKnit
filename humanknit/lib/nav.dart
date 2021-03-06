import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:humanknit/goals.dart';
import 'package:humanknit/leaderboard.dart';
import 'package:humanknit/posts.dart';
import 'package:humanknit/settings.dart';
import 'package:humanknit/profile.dart';

class Navigation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NavigationState();
  }
}

class _NavigationState extends State<Navigation> {
  var selectedIndex = 0;
  PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final iconSize = 30 / 896 * screenHeight;
    final List<Color> backgroundColors = [
      Colors.white,
      Color(0xffc1baff),
      Colors.white,
      Colors.white,
      Colors.white,
    ];
    final List<Widget> children = [
      Padding(padding: EdgeInsets.all(0), child: MainProfilePage()),
      Padding(padding: EdgeInsets.all(10), child: PostsPage()),
      Padding(padding: EdgeInsets.all(0), child: LeaderboardPage()),
      Padding(padding: EdgeInsets.all(0), child: GoalsPage()),
      Padding(padding: EdgeInsets.all(10), child: SettingsPage()),
    ];

    return MaterialApp(
      theme: ThemeData(fontFamily: 'AdventPro'),
      home: Scaffold(
        backgroundColor: backgroundColors[selectedIndex],
        body: SizedBox.expand(
          child: PageView(
            controller: pageController,
            onPageChanged: (index) {
              setState(() => selectedIndex = index);
            },
            children: children,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: Color.fromRGBO(255, 234, 167, 1),
          selectedItemColor: Color.fromRGBO(0, 206, 201, 0.5),  
          onTap: onItemTapped,
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
                new AssetImage("assets/images/post.png"),
                size: iconSize+4,
              ),
              title: Text(""),
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                new AssetImage("assets/images/trophy.jpg"),
                size: iconSize+4,
              ),
              title: Text(""),
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                new AssetImage("assets/images/target.png"),
                size: iconSize,
              ),
              title: Text(""),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                size: iconSize,
              ),
              title: Text(""),
            ),
          ],
        ),
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;

      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.easeOut);
    });
  }
}
