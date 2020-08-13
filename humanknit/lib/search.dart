import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:xml_parser/xml_parser.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

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
  final flutterWebviewPlugin = FlutterWebviewPlugin();
  List<Widget> children;
  var closed = false;
  double screenHeight = 0;
  double screenWidth = 0;
  var selected = [true];
  var searchString = "";
  Placemark location;
  var gotLocation = false;
  var advancedSearchPressed = false;
  var advancedSearchTFValues;
  var searchLocationStr = "";
  final eventfulAppKey = "R83whdM3ZPbzHzRf";
  List<String> eventfulCategoryTitles;
  List<String> eventfulCategoryIDs;
  List<String> eventfulCategoryIDsSelected;
  List<Widget> advancedSearchOptions;
  List<bool> eventfulCategoriesSelected;
  List<bool> advancedSearchValues;

  @override
  void dispose() {
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (type != EVENT_TYPE.VOTE) {
      selected.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    final nearYouTab = Padding(
      padding: EdgeInsets.all(screenWidth / 48),
      child: Text("Near You",
          style: TextStyle(
            fontSize: 36 / 896 * screenHeight,
          )),
    );

    final toggle = (type == EVENT_TYPE.VOTE)
        ? Container(
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xff000000)),
              borderRadius: BorderRadius.all(Radius.circular(1000)),
              color: Color(0xfffcba03),
            ),
            child: nearYouTab,
          )
        : ToggleButtons(
            isSelected: selected,
            onPressed: (int index) {
              onTogglePressed(index);
              setState(() {});
            },
            selectedColor: Color(0xffffffff),
            fillColor: Color(0xfffcba03),
            borderColor: Color(0xff000000),
            selectedBorderColor: Color(0xff000000),
            borderRadius: BorderRadius.all(
              Radius.circular(1000),
            ),
            children: [
              nearYouTab,
              Padding(
                padding: EdgeInsets.all(screenWidth / 48),
                child: Text(
                  "Search",
                  style: TextStyle(
                    fontSize: 36 / 896 * screenHeight,
                  ),
                ),
              ),
            ],
          );

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

    final searchBar = Padding(
      padding: EdgeInsets.only(left: screenWidth / 24, right: screenWidth / 24),
      child: TextField(
        onEditingComplete: () {
          FocusScope.of(context).unfocus();
          closed = false;
          children = null;
          setState(() {});
        },
        onChanged: (String s) {
          searchString = s;
        },
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
      ),
    );

    final advancedSearch = RaisedButton(
      color: Color(0xfffcba03),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1000),
      ),
      child: Padding(
        padding: EdgeInsets.all(screenWidth / 48),
        child: Text(
          "Advanced Search",
          style: TextStyle(
            fontSize: 24 / 896 * screenHeight,
          ),
        ),
      ),
      onPressed: () => setState(() {
        advancedSearchPressed = !advancedSearchPressed;
      }),
    );

    if (advancedSearchPressed) {
      showAdvancedSearchOptions();
    } else {
      advancedSearchOptions = null;
    }

    !selected[0] ? searchMethod(true) : searchMethod(false);

    return Scaffold(
      backgroundColor: Color(0xff6c7bff),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            flex: 2,
            child: Column(
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
                  child: toggle,
                ),
              ],
            ),
          ),
          Flexible(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                selected[0] ? SizedBox(height: 0) : Flexible(child: searchBar),
                selected[0]
                    ? SizedBox(height: 0)
                    : Flexible(child: advancedSearch),
                (!selected[0] && advancedSearchPressed)
                    ? Padding(
                        padding: EdgeInsets.only(
                          left: screenWidth / 6,
                          right: screenWidth / 6,
                        ),
                        child: Column(children: advancedSearchOptions),
                      )
                    : SizedBox(height: 0),
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
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xffffffff)),
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
          ),
        ],
      ),
    );
  }

  void onTogglePressed(int index) {
    for (int i = 0; i < selected.length; i++) {
      this.selected[i] = i == index;
    }
    closed = false;
    children = null;
  }

  SearchPageState(EVENT_TYPE t) {
    type = t;
    switch (type) {
      case EVENT_TYPE.VOLUNTEER:
        title = "Volunteering Events";
        searchMethod = getVolunteerEventsList;
        advancedSearchValues = [true, false];
        advancedSearchTFValues = ["", ""];
        break;
      case EVENT_TYPE.VOTE:
        title = "Voting Events";
        searchMethod = getVotingEventsList;
        break;
      case EVENT_TYPE.COMMUNITY:
        title = "Community Events";
        searchMethod = getCommunityEventsList;
        advancedSearchValues = [false, false];
        advancedSearchTFValues = [""];
        if (eventfulCategoryTitles == null || eventfulCategoryIDs == null) {
          getCommunityEventCategories();
        }
        break;
    }
  }

  void showAdvancedSearchOptions() {
    switch (type) {
      case EVENT_TYPE.VOLUNTEER:
        advancedSearchOptions = [
          CheckboxListTile(
            title: Text(
              "Virtual",
              style: TextStyle(
                fontSize: 36 / 896 * screenHeight,
              ),
            ),
            value: advancedSearchValues[0],
            activeColor: Color(0xfffcba03),
            onChanged: (bool value) {
              setState(() {
                children = null;
                closed = false;
                advancedSearchValues[0] = value;
                advancedSearchValues[1] = !value;
              });
            },
          ),
          Divider(
            color: Color(0xffffffff),
          ),
          CheckboxListTile(
            title: Text(
              "Location",
              style: TextStyle(
                fontSize: 36 / 896 * screenHeight,
              ),
            ),
            value: advancedSearchValues[1],
            activeColor: Color(0xfffcba03),
            onChanged: (bool value) {
              children = null;
              closed = false;
              setState(() {
                advancedSearchValues[1] = value;
                advancedSearchValues[0] = !value;
              });
            },
          ),
          advancedSearchValues[1]
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: TextField(
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                          setSearchStr();
                          children = null;
                          closed = false;
                          setState(() {});
                        },
                        onChanged: (value) {
                          advancedSearchTFValues[0] = value;
                        },
                        decoration: InputDecoration(
                          fillColor: Color(0xffffffff),
                          filled: true,
                          hintText: "City",
                          hintStyle: TextStyle(
                            fontSize: 18 / 896 * screenHeight,
                            color: Color(0xffb1b1b1),
                          ),
                          prefixIcon: Transform.scale(
                            scale: 0.2,
                            child: ImageIcon(
                              AssetImage("assets/images/location.png"),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Color(0xffb1b1b1)),
                          ),
                        ),
                      ),
                    ),
                    VerticalDivider(),
                    Flexible(
                      child: TextField(
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                          setSearchStr();
                          children = null;
                          closed = false;
                          setState(() {});
                        },
                        onChanged: (value) {
                          advancedSearchTFValues[1] = value;
                        },
                        decoration: InputDecoration(
                          fillColor: Color(0xffffffff),
                          filled: true,
                          hintText: "State",
                          hintStyle: TextStyle(
                            fontSize: 18 / 896 * screenHeight,
                            color: Color(0xffb1b1b1),
                          ),
                          prefixIcon: Transform.scale(
                            scale: 0.2,
                            child: ImageIcon(
                              AssetImage("assets/images/location.png"),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Color(0xffb1b1b1)),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : SizedBox(height: 0),
        ];
        break;
      case EVENT_TYPE.VOTE:
        break;
      case EVENT_TYPE.COMMUNITY:
        advancedSearchOptions = [
          CheckboxListTile(
            title: Text(
              "Location",
              style: TextStyle(
                fontSize: 36 / 896 * screenHeight,
              ),
            ),
            value: advancedSearchValues[0],
            activeColor: Color(0xfffcba03),
            onChanged: (bool value) {
              setState(() {
                advancedSearchValues[0] = value;
              });
            },
          ),
          advancedSearchValues[0]
              ? TextField(
                  onChanged: (value) {
                    advancedSearchTFValues[0] = value;
                  },
                  onEditingComplete: () {
                    FocusScope.of(context).unfocus();
                    children = null;
                    closed = false;
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    fillColor: Color(0xffffffff),
                    filled: true,
                    hintText: "Zip Code",
                    hintStyle: TextStyle(
                      fontSize: 18 / 896 * screenHeight,
                      color: Color(0xffb1b1b1),
                    ),
                    prefixIcon: Transform.scale(
                      scale: 0.2,
                      child: ImageIcon(
                        AssetImage("assets/images/location.png"),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Color(0xffb1b1b1)),
                    ),
                  ),
                )
              : SizedBox(height: 0),
          Divider(
            color: Color(0xffffffff),
          ),
          CheckboxListTile(
            title: Text(
              "Category",
              style: TextStyle(
                fontSize: 36 / 896 * screenHeight,
              ),
            ),
            value: advancedSearchValues[1],
            activeColor: Color(0xfffcba03),
            onChanged: (bool value) async {
              presentCategoryDialog();
            },
          ),
        ];
        break;
    }
    setState(() {});
  }

  void setSearchStr() {
    searchLocationStr = advancedSearchTFValues[0].isEmpty
        ? advancedSearchTFValues[1]
        : "${advancedSearchTFValues[0]}, ${advancedSearchTFValues[1]}";
  }

  void getCommunityEventCategories() async {
    final url =
        "http://api.eventful.com/rest/categories/list?app_key=$eventfulAppKey";

    final response = await http.get(url);

    final xml = XmlDocument.fromString(response.body);
    final titleElements = xml.getElementsWhere(name: 'name');
    final idElements = xml.getElementsWhere(name: 'id');

    eventfulCategoryTitles = List<String>();
    eventfulCategoryIDs = List<String>();
    eventfulCategoriesSelected = List<bool>();

    titleElements.forEach((node) => eventfulCategoryTitles.add(node.text));
    idElements.forEach((node) => eventfulCategoryIDs.add(node.text));
    for (int i = 0; i < eventfulCategoryTitles.length; i++) {
      eventfulCategoriesSelected.add(false);
    }
  }

  void presentCategoryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(fontFamily: "BungeeInline"),
          child: AlertDialog(
            backgroundColor: Color(0xfffcba03),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            title: Text(
              'Choose Event Categories',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff000000),
              ),
            ),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: eventfulCategoryTitles.length,
                          itemBuilder: (BuildContext context, int index) {
                            return CheckboxListTile(
                              title: Text(
                                eventfulCategoryTitles[index],
                                style: TextStyle(
                                  fontSize: 36 / 896 * screenHeight,
                                ),
                              ),
                              value: eventfulCategoriesSelected[index],
                              activeColor: Color(0xfffcba03),
                              onChanged: (bool value) {
                                setState(() {
                                  eventfulCategoriesSelected[index] = value;
                                });
                              },
                            );
                          },
                          shrinkWrap: true,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton(
                            child: Text(
                              'Save',
                              style: TextStyle(color: Color(0xff6c7bff)),
                            ),
                            onPressed: () {
                              advancedSearchValues[1] =
                                  eventfulCategoriesSelected.contains(true);
                              children = null;
                              closed = false;
                              setEventfulCategoryIDSelected();
                              Navigator.of(context).pop();
                              this.setState(() {});
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void setEventfulCategoryIDSelected() {
    eventfulCategoryIDsSelected = List<String>();
    for (int i = 0; i < eventfulCategoriesSelected.length; i++) {
      if (eventfulCategoriesSelected[i]) {
        eventfulCategoryIDsSelected.add(eventfulCategoryIDs[i]);
      }
    }
  }

  void getVotingEventsList(bool search) async {
    if (closed) {
      return;
    }

    final appKey = "AIzaSyCq5JPOtJ-CFV2pYV02KhV_oYvmNhd9wlU";
    final url = Uri.parse(
        'https://www.googleapis.com/civicinfo/v2/elections?key=' + appKey);

    final response = await http.get(url);

    final elections = jsonDecode(response.body);
    var titleStrings = List<String>();
    var locationStrings = List<String>();
    var dateStrings = List<String>();

    elections["elections"].forEach((election) {
      titleStrings.add(election["name"]);
      locationStrings.add("Your Local Polling Place");
      dateStrings.add(election["electionDay"]);
    });

    children = getEventChildren(titleStrings, locationStrings, dateStrings);
    closed = true;
    setState(() {});
  }

  void getCommunityEventsList(bool search) async {
    if (closed) {
      return;
    }

    var url = 'http://api.eventful.com/rest/events/search?app_key=' +
        eventfulAppKey +
        '&date=Future';
    if (!search) {
      if (!gotLocation) {
        location = await getUserLocation();
        gotLocation = true;
      }
      url += "&l=" + Uri.encodeComponent(location.postalCode.toString());
    } else {
      url += "&q=$searchString";
      if (advancedSearchPressed) {
        if (advancedSearchValues[0]) {
          url += "&l=" + advancedSearchTFValues[0];
        }
        if (advancedSearchValues[1]) {
          url += "&category=";
          for (int i = 0; i < eventfulCategoryIDsSelected.length; i++) {
            url += eventfulCategoryIDsSelected[i];
            if (i < eventfulCategoryIDsSelected.length - 1) {
              url += ",";
            }
          }
        }
      }
    }

    final response = await http.get(url);

    final xml = XmlDocument.fromString(response.body);
    final titleElements = xml.getElementsWhere(name: 'title');
    final locationElements = xml.getElementsWhere(name: 'venue_address');
    final dateElements = xml.getElementsWhere(name: 'start_time');

    var titleStrings = List<String>();
    var locationStrings = List<String>();
    var dateStrings = List<String>();

    titleElements.forEach((node) => titleStrings.add(node.text));
    locationElements.forEach((node) {
      locationStrings.add(node.text ?? "");
    });
    dateElements.forEach((node) => dateStrings.add(node.text));

    children = getEventChildren(titleStrings, locationStrings, dateStrings);
    closed = true;
    setState(() {});
  }

  Future<Placemark> getUserLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    final currentPos = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          currentPos.latitude, currentPos.longitude);

      return p[0];
    } catch (e) {
      print(e);
    }
  }

  void getVolunteerEventsList(bool search) async {
    if (closed) {
      return;
    }

    String url = "https://www.volunteermatch.org/search/";
    if (search) {
      url += "?k=" + searchString;
      if (advancedSearchPressed) {
        if (advancedSearchValues[0]) {
          url += "&v=true";
        } else {
          url += "&l=" + Uri.encodeComponent(searchLocationStr);
        }
      } else {
        url += "&v=true";
      }
    } else {
      if (!gotLocation) {
        location = await getUserLocation();
        gotLocation = true;
      }
      url += "?l=" + Uri.encodeComponent(location.locality.toString());
    }

    flutterWebviewPlugin.launch(url, hidden: true);
    flutterWebviewPlugin.onStateChanged.listen((state) async {
      if (state.type == WebViewState.finishLoad) {
        sleep(Duration(milliseconds: 250));
        final html = flutterWebviewPlugin
            .evalJavascript("document.documentElement.outerHTML");
        html.then((value) {
          final urlEndings = getStrings(
              value,
              "<a data-linktype=\"opp\" href=\"",
              "\" class=\"link-body-text psr_link\">");
          var titles = List<String>();
          var locations = List<String>();

          titles = getStrings(
              value,
              "class=\"link-body-text pub-srp-opps__title ga-track-to-opp-details\">\n                      ",
              "</a>");
          locations =
              getStrings(value, "<div class=\"pub-srp-opps__loc\">", "</div>");

          final dates =
              getStrings(value, "<span class=\"opp_ongoing\">", "</span>");

          children = getEventChildren(titles, locations, dates);
          closed = true;
          setState(() {});
        });
      }
    });
  }

  void presentDetailsDialog(String date, String url) {}

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
