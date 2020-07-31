import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:humanknit/friendprofile.dart';

class MakeFriendsPage extends StatefulWidget {
  @override
  _MakeFriendsPageState createState() => _MakeFriendsPageState();
}

class _MakeFriendsPageState extends State<MakeFriendsPage> {

  static final _pageKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  ScrollController _scrollControl = new ScrollController();

  List<String> _searchedUserPFPS = List<String>();
  List<String> _searchedUserNames = List<String>();
  List<String> _searchedUserUsernames = List<String>();
  List<String> _searchedUserUIDS = List<String>();

  Future<int> fetchUsers(String username) async {
    setState(() {
      _searchedUserPFPS.clear();
      _searchedUserUsernames.clear();
      _searchedUserNames.clear();
      _searchedUserUIDS.clear();
    });
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String userUID = user.uid;
    final QuerySnapshot users = await Firestore.instance.collection("users").getDocuments();
    final List<DocumentSnapshot> userDocs = users.documents;
    List<String> searchedUserPFPS = List<String>();
    List<String> searchedUserNames = List<String>();
    List<String> searchedUserUsernames = List<String>();
    List<String> searchedUserUIDS = List<String>();
    await userDocs.forEach((DocumentSnapshot user) async {
      String currentUID = user.data["uid"];
      DocumentReference currentProfileDataDocument = await Firestore.instance.document("users/$currentUID/data/profileData");
      currentProfileDataDocument.get().then((datasnapshot) {
        if (datasnapshot.exists) {
          String currentName = datasnapshot.data["name"].toString();
          print(currentName);
          if (currentName.contains(username) && currentUID != userUID) {
            searchedUserNames.add(currentName);
            searchedUserPFPS.add(datasnapshot.data["pic"].toString());
            searchedUserUsernames.add(user.data["name"]);
            searchedUserUIDS.add(user.data["uid"]);
            setState(() {
              _searchedUserNames = searchedUserNames;
              _searchedUserPFPS = searchedUserPFPS;
              _searchedUserUsernames = searchedUserUsernames;
              _searchedUserUIDS = searchedUserUIDS;
              print(_searchedUserUsernames);
            });
          }
        }
      });
    });
  }




  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: <Widget>[
            AppBar(
              backgroundColor: Colors.black,
              actions: <Widget>[
              ],
            ),
            Form(
              key: _pageKey,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20/692 * height, left: 20/360 * width, right: 20/360 * width),
                    child: TextFormField(
                      controller: _username,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter a username";
                        }
                        return null;
                      },
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        decoration: InputDecoration(
                          errorStyle: TextStyle(fontSize: 8),
                          contentPadding: EdgeInsets.only(top: 4/692 * height, bottom: 4/692 * height, left: 15/360 * width),
                          hintText: "Name",
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(100.0),
                            ),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(177, 177, 177, 1),
                              width: 0.5,
                            ),
                          ),
                        )
                    ),
                    ),
                  ),
                  Container(
                      child: Padding(
                        padding: EdgeInsets.only(top: 40/692 * height, left: 40/360 * width, right: 40/360 * width),
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                                side: BorderSide(color: Colors.grey)),
                            color: Color.fromRGBO(252, 186, 3, 1),
                            onPressed: () async {
                              if (_pageKey.currentState.validate()) {
                                fetchUsers(_username.text);
        
                              }
                            },
                            child: Text('Search for Users',
                                style:
                                TextStyle(fontSize: 20, color: Colors.white))
                        ),
                      )
                  ),
                  SingleChildScrollView(
                    child: Container(
                      height: 450,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        controller: _scrollControl,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, index) {
                          return(getTile(index));
                      },
                      itemCount: _searchedUserUsernames.length,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  getTile(int position) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String username = _searchedUserUsernames[position];
    String name = _searchedUserNames[position];
    String pfp = _searchedUserPFPS[position];
    String uid = _searchedUserUIDS[position];
    return Container(
      child: Card(
        child: ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => FriendProfilePage(friendUID: uid,)));
          },
          contentPadding: EdgeInsets.symmetric(vertical: 8/692 * height, horizontal: 6/360 * width),
          leading: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(pfp),
                    fit: BoxFit.cover
                ),
                border: Border.all(
                    color: Colors.black,
                    width: 2
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(500),
                )
            ),
          ),
          title: Text(
            name,
          ),
          subtitle: Text(
            username,
          ),
        ),
      ),
    );
  }
}
