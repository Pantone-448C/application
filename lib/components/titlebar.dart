import 'package:application/components/apptheme.dart';
import 'package:application/pages/profile/view/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../pages/login/view/login.dart';

void handleProfileButton(BuildContext context) {
  if (FirebaseAuth.instance.currentUser == null) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
  } else {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(),
        ));
  }
}

class Titlebar extends StatelessWidget implements PreferredSizeWidget {
  static const titleSize = 30.0;
  static const barHeight = WanTheme.TITLEBAR_HEIGHT;

  @override
  Size get preferredSize => Size.fromHeight(barHeight);

  @override
  Widget build(BuildContext context) {
    /* Transparent status bar on android -- not sure about apple */
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: WanTheme.colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
    /* Ignore notch and status bar */
    return Container(
      child: SafeArea(
          child: AppBar(
        actions: [
          IconButton(
            color: WanTheme.colors.grey,
            icon: Icon(
              Icons.account_circle_outlined,
            ),
            onPressed: () {
              handleProfileButton(context);
            },
          ),
        ],
        title: Text('wanderlist',
            style: TextStyle(
              color: WanTheme.colors.pink,
              fontFamily: 'Pacifico',
              fontSize: titleSize,
            )),
        backgroundColor: WanTheme.colors.white,
        elevation: 0,
      )),
    );
  }
}
