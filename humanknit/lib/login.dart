import 'package:flutter/material.dart';
import 'package:humanknit/forgotpassword.dart';
import 'package:humanknit/signup.dart';
import 'nav.dart';

class LoginScreen extends StatelessWidget {
  final logoImage = new Image.asset('assets/images/logo.png');
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print(width);
    print(height);
    return MaterialApp(
      theme: ThemeData(fontFamily: 'BungeeInline'),
      home: Scaffold(
        body: Column(
          children: [
            Padding(
              child: Image.asset('assets/images/logo.png'),
              padding: EdgeInsets.only(
                  left: 0.15 * width, right: 0.15 * width, top: 20, bottom: 20),
            ),
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Expanded(
      child: Material(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 0.15 * width, right: 0.15 * width),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter an email";
                        }
                        return null;
                      },
                      style: TextStyle(
                        fontSize: 18 / 896 * height,
                        //height: 1.5,
                      ),
                      decoration: InputDecoration(
                        errorStyle: TextStyle(fontSize: 8 / 896 * height),
                        contentPadding:
                        const EdgeInsets.only(top: 4, bottom: 4, left: 15),
                        hintText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(1000),
                          ),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(177, 177, 177, 1),
                            width: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 0.15 * width, right: 0.15 * width, top: 9/896 * height),
                    child: TextFormField(
                      obscureText: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter a password";
                        }
                        return null;
                      },
                      style: TextStyle(
                        fontSize: 18 / 896 * height,
                        //height: 1.5,
                      ),
                      decoration: InputDecoration(
                        errorStyle: TextStyle(fontSize: 8 / 896 * height),
                        contentPadding:
                        const EdgeInsets.only(top: 4, bottom: 4, left: 15),
                        hintText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(1000),
                          ),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(177, 177, 177, 1),
                            width: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 0.15 * width,
                    right: 0.15 * width),
                child: Container(
                  width: double.infinity,
                  child: RaisedButton(
                    padding: EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1000),
                        side: BorderSide(color: Colors.grey)),
                    color: Color.fromRGBO(252, 186, 3, 1),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Navigation()),
                        );
                      }
                    },
                    child: Text('Login',
                        style: TextStyle(
                            fontSize: 24 / 896 * height, color: Colors.white)),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(
                      left: 0.25 * width, right: 0.25 * width),
                  child: Container(
                      width: double.infinity,
                      child: RaisedButton(
                        padding: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1000),
                            side: BorderSide(color: Colors.grey)),
                        color: Color.fromRGBO(108, 123, 255, 0.5),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen()),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20 / 896 * height,
                          ),
                        ),
                      ))),
              Text(
                'Don\'t have an account?',
                style: TextStyle(
                  fontSize: 18 / 896 * height,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 0.30 * width, right: 0.30 * width),
                child: Container(
                  width: double.infinity,
                  child: RaisedButton(
                    padding: EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1000),
                        side: BorderSide(color: Colors.grey)),
                    color: Color.fromRGBO(108, 123, 255, 1),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupScreen()),
                      );
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24 / 896 * height,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}