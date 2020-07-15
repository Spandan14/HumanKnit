import 'package:flutter/material.dart';
import 'package:humanknit/profile.dart';
import 'package:humanknit/friends.dart';
import 'package:humanknit/experiences.dart';
import 'package:humanknit/settings.dart';

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
    final List<Widget> children = [
      Padding(padding: EdgeInsets.all(10), child: ProfilePage()),
      Padding(padding: EdgeInsets.all(10), child: FriendsPage()),
      Padding(padding: EdgeInsets.all(10), child: ExperiencesPage()),
      Padding(padding: EdgeInsets.all(10), child: SettingsPage()),
    ];

    return MaterialApp(
      theme: ThemeData(fontFamily: 'BungeeInline'),
      home: Scaffold(
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
          backgroundColor: Color(0xffffb86f),
          selectedItemColor: Color(0xffd90368),
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

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;

      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.easeOut);
    });
  }
}
