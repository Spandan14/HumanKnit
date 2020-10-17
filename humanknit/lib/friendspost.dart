import 'dart:ui';
import 'package:humanknit/theme.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:humanknit/friendprofile.dart';
class FriendPostsPage extends StatefulWidget {
  final String userUID;

  FriendPostsPage({Key key, @required this.userUID}) : super(key: key);


  @override
  _FriendPostsPageState createState() => _FriendPostsPageState();
}

class _FriendPostsPageState extends State<FriendPostsPage> {

  static ScrollController _scrollController = new ScrollController();

  static List<String> _postCaptions = List<String>();
  static List<String> _postDates = List<String>();
  static List<String> _postLocations = List<String>();
  static List<String> _postPics = List<String>();
  static List<String> _postTypes = List<String>();
  static List<String> _postUIDS = List<String>();
  static List<String> _postAuthors = List<String>();
  static List<String> _postAuthorUIDS = List<String>();
  static List<int> _postLikes = List<int>();
  Future<void> fetchPostsData() async {
    print("data");
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String uid = user.uid;
    QuerySnapshot posts = await Firestore.instance.collection("users/${widget.userUID}/data/postsData/posts").getDocuments();
    List<DocumentSnapshot> postsDocs = await posts.documents;
    List<String> postCaptions = List<String>();
    List<String> postDates = List<String>();
    List<String> postLocations = List<String>();
    List<String> postPics = List<String>();
    List<String> postTypes = List<String>();
    List<String> postUIDS = List<String>();
    List<String> postAuthors = List<String>();
    List<String> postAuthorUIDS = List<String>();
    List<int> postLikes = List<int>();
    await print(posts);
    postsDocs.forEach((postsnapshot) async {
      DocumentReference profile = await Firestore.instance.document("users/${widget.userUID}");
      DocumentSnapshot profilesnapshot;
      await profile.get().then((snapshot) {profilesnapshot = snapshot;});
      await postCaptions.add(postsnapshot.data["caption"]);
      await postDates.add(postsnapshot.data["date"].toString());
      await postLocations.add(postsnapshot.data["location"]);
      await postPics.add(postsnapshot.data["pic"]);
      await postTypes.add(postsnapshot.data["type"]);
      await postUIDS.add(postsnapshot.documentID);
      await postAuthors.add(profilesnapshot.data["name"]);
      await postAuthorUIDS.add(widget.userUID);
      await postLikes.add(postsnapshot.data["likes"]);
      setState(() {
        print("sett");
        _postCaptions = new List.from(postCaptions.reversed);
        _postDates = new List.from(postDates.reversed);
        _postLocations = new List.from(postLocations.reversed);
        _postPics = new List.from(postPics.reversed);
        _postTypes = new List.from(postTypes.reversed);
        _postUIDS = new List.from(postUIDS.reversed);
        _postAuthors = new List.from(postAuthors.reversed);
        _postAuthorUIDS = new List.from(postAuthorUIDS.reversed);
        _postLikes = new List.from(postLikes.reversed);
        first = false;
        print(postUIDS);
      });
    });
  }

  doLike(int position) async {
    List<String>likeUsers = List<String>();
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;
    var author = _postAuthorUIDS[position];
    var postUID = _postUIDS[position];
    print(postUID);
    QuerySnapshot likes = await Firestore.instance.collection("users/$author/data/postsData/posts/$postUID/likes").getDocuments();
    List<DocumentSnapshot> likeDocs = await likes.documents;
    await likeDocs.forEach((likesnapshot) async {
      likeUsers.add(likesnapshot.data["likedby"]);
    });
    if (likeUsers.contains(uid)) {
      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData (
                  fontFamily: 'BungeeInline'
              ),
              child: AlertDialog (
                backgroundColor: Color(0xfffeefb3),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.all(Radius.circular(20.0)),
                ),
                title: Text(
                  'Posts',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff875053),
                  ),
                ),
                content: Column (
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "You have already liked this post!",
                      style: TextStyle(
                        color: Color(0xffaa767c),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Row (
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton(
                            child: Text(
                              'OK',
                              style: TextStyle(
                                color: Color(0xff875053),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              return null;
                            },
                          )
                        ]
                    ),
                  ],
                ),
              ),
            );
          }
      );
    }
    else {
      await Firestore.instance.document("users/$author/data/postsData/posts/$postUID/likes/$uid").setData({"likedby": uid}, merge: true);
      await Firestore.instance.document("users/$author/data/postsData/posts/$postUID").setData({"likes": FieldValue.increment(1)}, merge: true);
      _postLikes[position]++;
      var now = new DateTime.now();
      int currentMonth = now.month;
      String community = "";
      DocumentReference userDoc = await Firestore.instance.document("users/$author");
      userDoc.get().then((datasnapshot) async {
        print(datasnapshot.data['community']);
        community = datasnapshot.data['community'];
        print("$community");
        await Firestore.instance.document("communities/$community/users/$author").setData({
          "$currentMonth": FieldValue == null ? 0 : FieldValue.increment(1),
        }, merge: true);
      });
      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData (
                  fontFamily: 'BungeeInline'
              ),
              child: AlertDialog (
                backgroundColor: Color(0xfffeefb3),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.all(Radius.circular(20.0)),
                ),
                title: Text(
                  'Posts',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff875053),
                  ),
                ),
                content: Column (
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Post Liked Successfully",
                      style: TextStyle(
                        color: Color(0xffaa767c),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Row (
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton(
                            child: Text(
                              'OK',
                              style: TextStyle(
                                color: Color(0xff875053),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              return null;
                            },
                          )
                        ]
                    ),
                  ],
                ),
              ),
            );
          }
      );
    }
    setState(() {
    });
  }

  getPostCard(int position) {
    print("posttile");
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String caption, date, location, pic, type, author;
    int likes;
    caption = _postCaptions[position];
    date = _postDates[position];
    location = _postLocations[position];
    pic = _postPics[position];
    type = _postTypes[position];
    author = _postAuthors[position];
    likes = _postLikes[position];
    Color postColor;
    postColor = Colors.black;
    return Center(
      child: Container(
        child: Card(
          child: Container(
            width: 330/360 * width,
            height: 560/692 * height,
            child: Column(
              children: <Widget>[
                Container(
                  height: 105/692 * height,
                  color: postColor,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.topLeft,
                          height: 30/692 * height,
                          child: Text(
                            author,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0, left: 8),
                        child: Container(
                          height: 50/692 * height,
                          alignment: Alignment.topLeft,
                          child: Text(
                            "At " + location + "\nOn " + date,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: postColor,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10/692 * width),
                    child: Container(
                      alignment: Alignment.center,
                      height: 380/692 * height,
                      width: 330/360 * width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(pic), fit: BoxFit.cover),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: postColor,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8, left: 8),
                    child: Container(
                      color: postColor,
                      width: 330/360 * width,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            width: 250/360 * width,
                            child: Text(
                              caption,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white
                              ),
                            ),
                          ),

                          Container(
                            child: Text(
                              likes.toString(),
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            ),
                          ),
                          IconButton(
                            color: Colors.black,
                            icon: Icon(
                              Icons.favorite_border,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {doLike(position);},
                          ),


                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool first = true;
  @override
  Widget build(BuildContext context) {
    if (first) {
      fetchPostsData();
      setState(() {});
      first = false;
    }
    if (_postUIDS.length == 0) {
      return Scaffold(
        body: Column(
          children: <Widget>[
            AppBar(
              backgroundColor: Colors.black,
              actions: <Widget>[
              ],
            ),
            Container(
              color: AppTheme.THEME_COLORS[1][0],
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 600,
                      alignment: Alignment.center,
                      child: Text(
                        "No posts in your feed",
                        style: TextStyle(
                            fontFamily: "AdventPro",
                            fontSize: 24,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                  ],
                )
            ),
          ],
        ),
      );
    }
    print(widget.userUID);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        color: AppTheme.THEME_COLORS[1][0],
        child: Column(
          children: <Widget>[
            AppBar(
              backgroundColor: Colors.black,
              actions: <Widget>[
              ],
            ),
            SingleChildScrollView(
              child: Container(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: _postUIDS.length,
                  itemBuilder: (BuildContext context, index) {
                    return(getPostCard(index));
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
