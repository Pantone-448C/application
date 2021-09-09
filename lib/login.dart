import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:application/sizeconfig.dart';
import 'package:application/apptheme.dart';

import 'signup.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  var errorMessage = "";

  void login() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text,
          password: password.text,
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        setState(() {
          errorMessage = "No user found for that email.";
        });
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        setState(() {
          errorMessage = e.code;
        });
      }
    }
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var sz = SizeConfig(context);
    var logoHeight = sz.hPc * 33;
    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      logoHeight = 0.0;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Column (
        children: [
          Container(
            height: logoHeight,
            width: sz.wPc * 70,
            padding: EdgeInsets.only(top: 40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
            ),
            child: Center(
              child: Text(
                "wanderlist",
                style: theme.text.logo,
                )
              )
            ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: email,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: password,
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SignupPage()
                )
              );
            },
            child: Text(
              'Sign up',
              style: theme.text.signupButton,
            ),
          ),
          Container(
            height: 50,
            width: sz.wPc * 70,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(20)),
            child: TextButton(
              onPressed: () {
                login();
              },
              child: Text(
                'Login',
                style: theme.text.loginButton,
              ),
            ),
          ),
          Container(
            height: 50,
            width: 250,
            child: Center(
              child: Text(
                errorMessage,
                style: theme.text.errorLabel
              ),
            )
          ),
        ],
      ),
    );
  }
}