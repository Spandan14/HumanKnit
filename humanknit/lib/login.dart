import 'package:flutter/material.dart';
import 'package:humanknit/forgotpassword.dart';
import 'package:humanknit/signup.dart';
import 'nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatelessWidget {
  final logoImage = new Image.asset('assets/images/logo.png');
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
            LoginForm(),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _pass = TextEditingController();
  final TextEditingController _email = TextEditingController();

  void handleLoginError(var err) {
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
      case "ERROR_USER_NOT_FOUND":
        errorText = "This user does not exist.";
        break;
      case "ERROR_WRONG_PASSWORD":
        errorText = "This password is incorrect.";
        break;
      case "ERROR_USER_DISABLED":
        errorText = "This user has been disabled.";
        break;
      default:
        errorText = "An unknown error occurred.";
    }
    showDialog(
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
      key: _formKey,
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
              height: 44,
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 0.15 * width, right: 0.15 * width, top: 4),
                  child: TextFormField(
                    controller: _pass,
                    obscureText: true,
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
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 0.15 * width,
                      right: 0.15 * width,
                      top: 20,
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
                          if (_formKey.currentState.validate()) {
                            FirebaseAuth.instance.signInWithEmailAndPassword(email: _email.text, password: _pass.text).then((authResult) => Firestore.instance.collection("users").document(authResult.user.uid).get().then((DocumentSnapshot result) =>
                              Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Navigation()),
                            ))).catchError((err) => handleLoginError(err));
                          }
                        },
                        child: Text('Login',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                      )))),
          Container(
              color: Colors.white,
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 0.20 * width, right: 0.20 * width, bottom: 30),
                  child: Container(
                      width: 320,
                      height: 40,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                            side: BorderSide(color: Colors.grey)),
                        color: Color.fromRGBO(108, 123, 255, 0.5),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen()),
                          );
                        },
                        child: Text('Forgot Password?',
                            style: TextStyle(color: Colors.white)),
                      )))),
          Container(
              color: Colors.white,
              width: 360,
              child: Text(
                'Don\'t have an account?',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              )),
          Container(
              color: Colors.white,
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 0.30 * width, right: 0.30 * width, top: 10),
                  child: Container(
                      width: 120,
                      height: 40,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                            side: BorderSide(color: Colors.grey)),
                        color: Color.fromRGBO(108, 123, 255, 1),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupScreen()),
                          );
                        },
                        child: Text('Sign up',
                            style: TextStyle(color: Colors.white)),
                      ))))
        ],
      ),
    ));
  }
}
