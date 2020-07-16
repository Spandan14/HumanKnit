import 'package:flutter/material.dart';
import 'package:humanknit/events.dart';
import 'package:humanknit/stats.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> {
  var statsEventsSelected = [true, false];
  var selectedIndex = 0;
  var timeSelected = [true, false, false];
  final children = [StatsPage(), EventsPage()];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final nameText = Text(
      "Frank Gao",
      style: TextStyle(
        fontSize: 48 / 896 * screenHeight,
        color: Color(0xff71918d),
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
      fillColor: Color(0xff71918d),
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
      selectedColor: Color(0x8099c2a2),
      selectedBorderColor: Color(0xff93b1a7),
      borderColor: Color(0xff93b1a7),
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
              color: Color(0xff71918d),
            ),
          ),
        ),
        wrapInPaddingContainer(
          Text(
            "Year",
            style: TextStyle(
              fontSize: 14 / 896 * screenHeight,
              color: Color(0xff71918d),
            ),
          ),
        ),
        wrapInPaddingContainer(
          Text(
            "Month",
            style: TextStyle(
              fontSize: 14 / 896 * screenHeight,
              color: Color(0xff71918d),
            ),
          ),
        ),
      ],
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        new Flexible(
          flex: 2,
          child: Column(
            children: [
              nameText,
              SizedBox(height: 20),
              statsEventsToggle,
              SizedBox(height: 20),
              timeToggle,
            ],
          ),
        ),
        new Flexible(
          flex: 1,
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
