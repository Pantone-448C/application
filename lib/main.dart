import 'package:application/titlebar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:application/apptheme.dart';

import 'home/view/home_page.dart';
import 'components/activity_summary_item_large.dart';
import 'components/activity_summary_item_small.dart';
import 'login/view/login.dart';
import 'navbar.dart';
import 'titlebar.dart';

FirebaseAuth auth = FirebaseAuth.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
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
      theme: WanTheme.materialTheme,
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
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WanTheme.colors.offWhite,
      appBar: Titlebar(),
      body: Center(child: HomePage()),
      //   child: ListView(
      //     padding: EdgeInsets.only(
      //       left: 20,
      //       right: 20,
      //     ),
      //     children: <Widget>[
      //       Container(child: HomePage()),
      //     ],
      //   ),
      // ),
      bottomNavigationBar: Navbar(),
    );
  }
}
