import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml_events.dart';

enum EVENT_TYPE {
  VOLUNTEER,
  VOTE,
  COMMUNITY,
}

class SearchPage extends StatefulWidget {
  EVENT_TYPE type;

  @override
  State<StatefulWidget> createState() {
    return SearchPageState(type);
  }

  SearchPage(EVENT_TYPE t) {
    type = t;
  }
}

class SearchPageState extends State<SearchPage> {
  EVENT_TYPE type;
  var title;
  var searchMethod;
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  List<Widget> children;
  var closed = false;
  double screenHeight = 0;
  double screenWidth = 0;

  @override
  void dispose() {
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    final backButton = RaisedButton(
      color: Color(0xfffcba03),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1000),
      ),
      child: Padding(
        padding: EdgeInsets.all(screenWidth / 48),
        child: Text(
          "< Back",
          style: TextStyle(
            fontSize: 24 / 896 * screenHeight,
          ),
        ),
      ),
      onPressed: () => Navigator.of(context).pop(),
    );

    final titleText = Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 48 / 896 * screenHeight,
        color: Color(0xfffcba03),
      ),
    );
    final nearYouText = Text(
      "Near you:",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 42 / 896 * screenHeight,
        color: Color(0xfffcba03),
      ),
    );

    final searchBar = TextField(
      style: TextStyle(
        color: Color(0xffb1b1b1),
      ),
      decoration: InputDecoration(
        fillColor: Color(0xffffffff),
        filled: true,
        hintText: "Search",
        hintStyle: TextStyle(
          fontSize: 24 / 896 * screenHeight,
          color: Color(0xffb1b1b1),
        ),
        prefixIcon: Transform.scale(
          scale: 0.5,
          child: ImageIcon(
            AssetImage("assets/images/search.png"),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: Color(0xffb1b1b1)),
        ),
      ),
    );

    searchMethod();

    return Scaffold(
      backgroundColor: Color(0xff6c7bff),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Align(
            alignment: Alignment(-0.8, 1),
            child: backButton,
          ),
          Flexible(
            child: titleText,
          ),
          Flexible(
            child: nearYouText,
          ),
          Flexible(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.transparent,
              ),
              child: ListView(
                children: children ??
                    [
                      Center(
                        child: SizedBox(
                          width: 45 / 896 * screenHeight,
                          height: 45 / 896 * screenHeight,
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xffffffff)),
                          ),
                        ),
                      ),
                    ],
                shrinkWrap: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  SearchPageState(EVENT_TYPE t) {
    type = t;
    switch (type) {
      case EVENT_TYPE.VOLUNTEER:
        title = "Volunteering Events";
        searchMethod = getVolunteerEventsList;
        break;
      case EVENT_TYPE.VOTE:
        title = "Voting Events";
        break;
      case EVENT_TYPE.COMMUNITY:
        title = "Community Events";
        searchMethod = getCommunityEventsList;
        break;
    }
  }

  void getCommunityEventsList() async {
    if (closed) {
      return;
    }

    final appKey = "R83whdM3ZPbzHzRf";
    final url = Uri.parse(
        'http://api.eventful.com/rest/events/search?app_key=' +
            appKey +
            '&keywords=books&location=San+Diego&date=Future');
    final response = await http.get(url);

    final xml = XmlDocument.parse(response.body);
    final titles = xml.findAllElements("title");
    final locations = xml.findAllElements("venue_address");
    final dates = xml.findAllElements("start_time");

    var titleStrings = List<String>();
    var locationStrings = List<String>();
    var dateStrings = List<String>();

    titles.forEach((node) => titleStrings.add(node.text));
    locations.forEach((node) => locationStrings.add(node.text));
    dates.forEach((node) => dateStrings.add(node.text));
    
    children = getEventChildren(titleStrings, locationStrings, dateStrings);
    closed = true;
    setState(() {});
  }

  void getVolunteerEventsList() {
    if (closed) {
      return;
    }

    StringBuffer buffer =
        new StringBuffer("https://www.volunteermatch.org/search/");
    buffer.write("l=" + Uri.encodeComponent("Long+Grove%2C+IL%2C+USA"));

    flutterWebviewPlugin.launch(buffer.toString(), hidden: true);
    flutterWebviewPlugin.onProgressChanged.listen((progress) async {
      if (progress == 1) {
        flutterWebviewPlugin
            .evalJavascript("document.documentElement.outerHTML")
            .then((html) {
          final titles = getStrings(html, ". </span>", "\n");
          final locations = getStrings(html,
              "saddr=Current%20Location&amp;daddr=", "\" target=\"_blank\">");
          final dates =
              getStrings(html, "<span class=\"opp_ongoing\">", "</span>");

          children = getEventChildren(titles, locations, dates);
          flutterWebviewPlugin.close();
          closed = true;
          setState(() {});
        });
      }
    });
  }

  List<Widget> getEventChildren(
      List<String> titles, List<String> locations, List<String> dates) {
    var children = List<Widget>();
    for (int i = 0; i < titles.length; i++) {
      children.add(
        Padding(
          padding: EdgeInsets.only(
              left: screenWidth / 12,
              right: screenWidth / 12,
              top: screenWidth / 48,
              bottom: screenWidth / 48),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xffffffff),
              border: Border.all(
                color: Color(0xff000000),
              ),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Padding(
              padding: EdgeInsets.all(screenWidth / 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    titles[i],
                    textAlign: TextAlign.center,
                    maxLines: 5,
                    style: TextStyle(
                      fontSize: 30 / 896 * screenHeight,
                    ),
                  ),
                  SizedBox(
                    height: screenWidth / 6,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Image.asset("assets/images/location.png"),
                      ),
                      Flexible(
                        flex: 5,
                        child: Text(
                          locations[i],
                          textAlign: TextAlign.center,
                          maxLines: 5,
                          style: TextStyle(
                            fontSize: 22 / 896 * screenHeight,
                            color: Color(0xff6c7bff),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenWidth / 6,
                  ),
                  RaisedButton(
                    color: Color(0xfffcba03),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1000),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth / 16),
                      child: Text(
                        "Details >",
                        style: TextStyle(
                          fontSize: 36 / 896 * screenHeight,
                        ),
                      ),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return children;
  }

  List<String> getStrings(String html, String sStr, String eStr) {
    final startStr = sStr;
    final endStr = eStr;
    var titles = List<String>();

    while (html.indexOf(startStr) != -1) {
      final startIndex = html.indexOf(startStr);
      final endIndex = html.indexOf(endStr, startIndex + startStr.length);
      titles.add(html.substring(startIndex + startStr.length, endIndex));
      html = html.substring(endIndex, html.length);
    }
    return titles;
  }
}
