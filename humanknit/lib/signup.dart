import 'package:flutter/material.dart';
import 'package:humanknit/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print(width);
    print(height);
    return Container(
      color: Color.fromRGBO(255, 255, 255, 1),
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'BungeeInline'),
        home: Column(
          children: [
            Padding(
                child: Image.asset('assets/images/logo.png'),
                padding: EdgeInsets.only(
                    left: 0.15 * width,
                    right: 0.15 * width,
                    top: 20,
                    bottom: 20)),
            SignupForm(),
          ],
        ),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  static final _formKey1 = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _username = TextEditingController();

  void handleSignupError(var err) {
    print(err.code);
    String errorText;
    switch (err.code) {
      case "ERROR_INVALID_EMAIL":
        errorText = "The email address does not appear to have the correct format.";
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        errorText = "Too many requests right now. Try again later.";
        break;
      case "OPERATION_NOT_ALLOWED":
        errorText = "This operation is not allowed";
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        errorText = "This email address is already in use. Please use a different one.";
        break;
      case "ERROR_WEAK_PASSWORD":
        errorText = "This password is too weak. Try one with more than 6 characters.";
        break;
      default:
        errorText = "An unknown error occurred.";
    }
    showDialog(
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
            'An error has occurred',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff875053),
            ),
          ),
          content: Column (
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                errorText,
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Material(
        child: Form(
      key: _formKey1,
      child: Column(
        children: <Widget>[
          Container(
              color: Colors.white,
              height: 40,
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 0.15 * width, right: 0.15 * width, top: 0),
                  child: TextFormField(
                    controller: _email,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter an email";
                      }
                      return null;
                    },
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                    decoration: InputDecoration(
                        errorStyle: TextStyle(fontSize: 8),
                        contentPadding:
                            const EdgeInsets.only(top: 4, bottom: 4, left: 15),
                        hintText: "Email",
                        border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(100.0),
                            ),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(177, 177, 177, 1),
                              width: 0.5,
                            ))),
                  ))),
          Container(
              color: Colors.white,
              height: 40,
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 0.15 * width, right: 0.15 * width, top: 4),
                  child: TextFormField(
                    controller: _username,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter a username";
                      }
                      return null;
                    },
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                    decoration: InputDecoration(
                        errorStyle: TextStyle(fontSize: 8),
                        contentPadding:
                            const EdgeInsets.only(top: 4, bottom: 4, left: 15),
                        hintText: "Username",
                        border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(100.0),
                            ),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(177, 177, 177, 1),
                              width: 0.5,
                            ))),
                  ))),
          Container(
              color: Colors.white,
              height: 44,
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 0.15 * width, right: 0.15 * width, top: 4),
                  child: TextFormField(
                    obscureText: true,
                    controller: _pass,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter a password";
                      }
                      return null;
                    },
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                    decoration: InputDecoration(
                        errorStyle: TextStyle(fontSize: 8),
                        contentPadding:
                            const EdgeInsets.only(top: 4, bottom: 4, left: 15),
                        hintText: "Password",
                        border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(100.0),
                            ),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(177, 177, 177, 1),
                              width: 0.5,
                            ))),
                  ))),
          Container(
              color: Colors.white,
              height: 44,
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 0.15 * width, right: 0.15 * width, top: 4),
                  child: TextFormField(
                    controller: _confirmPass,
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please re-enter password";
                      }
                      if (value != _pass.text) {
                        return "Passwords do not match!";
                      }
                      return null;
                    },
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                    decoration: InputDecoration(
                        errorStyle: TextStyle(fontSize: 8),
                        contentPadding:
                            const EdgeInsets.only(top: 4, bottom: 4, left: 15),
                        hintText: "Confirm Password",
                        border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(100.0),
                            ),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(177, 177, 177, 1),
                              width: 0.5,
                            ))),
                  ))),
          Container(
              color: Colors.white,
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 0.15 * width,
                      right: 0.15 * width,
                      top: 40,
                      bottom: 20),
                  child: Container(
                      width: 400,
                      height: 60,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                            side: BorderSide(color: Colors.grey)),
                        color: Color.fromRGBO(252, 186, 3, 1),
                        onPressed: () {
                          if (_formKey1.currentState.validate()) {
                            FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email.text, password: _pass.text).then((authResult) => Firestore.instance.collection("users").document(authResult.user.uid).setData({
                              "uid": authResult.user.uid,
                              "name": _username.text,
                              "email": _email.text,
                            })).then((result) =>
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                )
                            ).catchError((err) => handleSignupError(err));

                          }
                        },
                        child: Text('Sign up',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                      )))),
        Container(
          color: Colors.white,
          width: width,
          height: height * 80/896,
          child: Padding (
            padding: EdgeInsets.only(top: height * 10/896, right: width * 100/416, left: width * 100/416),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                  side: BorderSide(color: Colors.grey)),
              color: Color(0xffaa767c),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Text('Back',
                  style:
                  TextStyle(fontSize: 20, color: Colors.white)
              ),
            )
          )
        )
        ],
      ),
    ));
  }
}
