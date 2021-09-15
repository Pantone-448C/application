import 'package:application/apptheme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();

  /**
   * Checks if email is available.
   */

  Future<bool> emailAvailable() async {
    var val =
        await FirebaseAuth.instance.fetchSignInMethodsForEmail(email.text);
    return val.isEmpty;
  }

  /**
   * Navigate to the next page
   * TODO: Move all the verification logic somewhere else
   */
  void navigateNextPage() async {
    if (!await emailAvailable()) {
      print("Email not available");
      return;
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SignupPasswordPage(firstName.text, lastName.text, email.text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sign Up"),
        ),
        body: ListView(children: [
          Container(
            height: 200,
            width: 350,
            padding: EdgeInsets.only(top: 40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
            ),
            child: Center(
                child: Text("Tell us about yourself",
                    style: TextStyle(
                      fontSize: 25,
                    ))),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: firstName,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'First name',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: lastName,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Last name',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: email,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email address',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: WanTheme.colors.pink,
                  borderRadius: BorderRadius.circular(15)),
              child: TextButton(
                onPressed: () {
                  navigateNextPage();
                },
                child: Text(
                  'Continue',
                  style: WanTheme.text.loginButton,
                ),
              ),
            ),
          )
        ]));
  }
}

class SignupPasswordPage extends StatefulWidget {
  SignupPasswordPage(this.firstName, this.lastName, this.email);

  final String firstName;
  final String lastName;
  final String email;

  _SignupPasswordPageState createState() => _SignupPasswordPageState();
}

class _SignupPasswordPageState extends State<SignupPasswordPage> {
  final password = TextEditingController();
  final confirmation = TextEditingController();

  Future<void> signup() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: widget.email, password: password.text);
      var users = FirebaseFirestore.instance.collection('users');
      users.doc(userCredential.user!.uid).set({
        'first_name': widget.firstName,
        'last_name': widget.lastName,
        'email': widget.email,
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sign Up"),
        ),
        body: ListView(children: [
          Container(
            height: 200,
            width: 350,
            padding: EdgeInsets.only(top: 40),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(200)),
            child: Center(
              child: Text(
                "Choose a new password",
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              obscureText: true,
              controller: password,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: confirmation,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Confirm password',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                color: WanTheme.colors.pink,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextButton(
                onPressed: () {
                  signup();
                },
                child: Text(
                  'Create Account',
                  style: WanTheme.text.loginButton,
                ),
              ),
            ),
          )
        ]));
  }
}
