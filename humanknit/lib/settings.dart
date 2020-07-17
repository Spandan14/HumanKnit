import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return MaterialApp (
      theme: ThemeData(fontFamily: 'BungeeInline'),
      home: Column (
        children: <Widget>[
          Container(
            child: Padding (
              padding: EdgeInsets.only(top: 40, left: 0.15 * width, right: 0.15 * width, bottom: 40),
              child: Material(
                child: Text (
                  "Settings",
                  style: TextStyle (
                    fontFamily: 'BungeeInline',
                    fontSize: 24
                  ),
                )
              ),
            )
          ),
          SettingsDropdowns()
        ],
      )
    );
  }
}

class SettingsDropdowns extends StatefulWidget {
  @override
  _SettingsDropdownsState createState() => _SettingsDropdownsState();
}

class _SettingsDropdownsState extends State<SettingsDropdowns> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
