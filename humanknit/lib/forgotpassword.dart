import 'package:flutter/material.dart';
import 'package:humanknit/forgotusername.dart';
import 'package:humanknit/login.dart';

class ForgotPasswordScreen extends StatelessWidget {
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
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter your username";
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
                              Navigator.push(
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
                  width: 360,
                  child: Text(
                    'Forgot Username?',
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
                          left: 0.25 * width, right: 0.25 * width, top: 10),
                      child: Container(
                          color: Colors.white,
                          width: 200,
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
                                    builder: (context) => ForgotUsernameScreen()),
                              );
                            },
                            child: Text('Use email',
                                style: TextStyle(color: Colors.white)),
                          )))),
              ]
            )
        )
    );
  }
}
