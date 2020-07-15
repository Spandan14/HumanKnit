import 'package:flutter/material.dart';
import 'package:humanknit/login.dart';

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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
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
                              if (_formKey.currentState.validate()) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginScreen()),
                                );
                              }
                            },
                            child: Text('Sign up',
                                style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                          )))),
            ],
          ),
        ));
  }
}
