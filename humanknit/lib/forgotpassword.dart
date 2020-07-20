import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:humanknit/login.dart';

class ForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final TextEditingController _email = TextEditingController();
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
            ForgotPasswordForm(),
          ],
        ),
      ),
    );
  }
}

class ForgotPasswordForm extends StatefulWidget {
  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  final TextEditingController _email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Material(
        child: Form(
            key: _formKey,
            child: Column(children: <Widget>[
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
                            return "Please enter your email";
                          }
                          return null;
                        },
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                        ),
                        decoration: InputDecoration(
                            errorStyle: TextStyle(fontSize: 8),
                            contentPadding: const EdgeInsets.only(
                                top: 4, bottom: 4, left: 15),
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
                child: Padding(
                    padding: EdgeInsets.only(
                        left: 0.20 * width, right: 0.20 * width, bottom: 30, top: 20),
                    child: Container(
                        width: 320,
                        height: 40,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                              side: BorderSide(color: Colors.grey)),
                          color: Color.fromRGBO(108, 123, 255, 0.5),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              resetPassword(_email.text);
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
                                          'Password Reset',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xff875053),
                                          ),
                                        ),
                                        content: Column (
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              "A password reset email has been sent. Please use it to reset your password.",
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
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                              );
                            }
                          },
                          child: Text('Reset password',
                              style: TextStyle(color: Colors.white)),
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
              ]
            )
        )
    );
  }
}
