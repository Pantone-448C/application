import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'login.dart';

FirebaseAuth auth = FirebaseAuth.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth.instance
      .authStateChanges()
      .listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WanderLists',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'WanderList'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override

  void checkSignedIn() {
    if (true || FirebaseAuth.instance.currentUser == null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage()
          )
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: (Colors.grey[500])!,
                ),
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: TextButton(
                  child: Text(
                    "Sign in",
                    style: TextStyle(fontFamily: 'RobotoMono'),
                  ),
                  onPressed: () {
                    checkSignedIn();
                  },
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: (Colors.grey[500])!,
                ),
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: TextButton(
                  child: Text(
                    "Sign out",
                    style: TextStyle(fontFamily: 'RobotoMono'),
                  ),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
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
