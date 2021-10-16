import 'package:application/apptheme.dart';
import 'package:application/pages/checkin/view/qr_view.dart';
import 'package:application/pages/search/view/search.dart';
import 'package:application/pages/userwanderlists/view/userwanderlists.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'pages/home/view/home_page.dart';
import 'pages/login/view/login.dart';

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
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wanderlist',
      theme: WanTheme.materialTheme,
      initialRoute: '/',
      routes: {
        '/': (context) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return AppContainer(title: 'Wanderlist');
              }
              return LoginPage();
            },
          );
        },
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppContainer extends StatefulWidget {
  AppContainer({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _AppContainerState createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _switch(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  void _gotoWanderlistsPage() {
    _pageController.jumpToPage(3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WanTheme.colors.offWhite,
      body: Center(
        child: PageView(
          // update navbar
          onPageChanged: (page) => setState(() => _selectedIndex = page),
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(child: HomePage(_gotoWanderlistsPage)),
            Container(child: SearchPage()),
            Container(child: WanQrPage()),
            Container(child: UserWanderlistsPage()),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        /* No switching animation */
        showSelectedLabels: false,
        /* Remove labels */
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
