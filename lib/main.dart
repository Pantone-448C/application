import 'package:application/titlebar.dart';
import 'package:application/userwanderlists/view/userwanderlists.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:application/apptheme.dart';

import 'home/view/home_page.dart';
import 'login/view/login.dart';
import 'titlebar.dart';
import 'package:application/checkin/view/qr_view.dart';

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
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _switch(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  void checkSignedIn() {
    if (true || FirebaseAuth.instance.currentUser == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WanTheme.colors.offWhite,
      appBar: Titlebar(),
      body: Center(
        child: PageView (
          // update navbar
          onPageChanged: (page) => setState(() => _selectedIndex = page),
          controller: _pageController,
          children: <Widget>[
            ListView (
              padding: EdgeInsets.only(left:20, right:20),
                children: <Widget>[
              Container(child: HomePage())]),
            Container(child: Text("Search Page")),
            Container(child: WanQrPage()),
            Container(child: UserWanderlistsPage()),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, /* No switching animation */
        showSelectedLabels: false, /* Remove labels */
        showUnselectedLabels: false,
        selectedItemColor: WanTheme.colors.pink,
        unselectedItemColor: WanTheme.colors.grey,
        items: [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
          ),
          BottomNavigationBarItem(
            label: 'Search',
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search_rounded),
          ),
          BottomNavigationBarItem(
            label: 'Flag',
            icon: Icon(Icons.flag_outlined),
            activeIcon: Icon(Icons.flag_rounded),
          ),
          BottomNavigationBarItem(
            label: 'Hotel',
            activeIcon: Icon(Icons.hotel_rounded),
            icon: Icon(Icons.hotel_outlined),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _switch,
      ),
    );
  }
}
