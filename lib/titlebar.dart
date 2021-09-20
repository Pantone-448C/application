import 'package:application/activity/view/activity_info.dart';
import 'package:application/apptheme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'login/view/login.dart';

class Titlebar extends StatelessWidget implements PreferredSizeWidget {
  void checkSignedIn(BuildContext context) {
    if (true || FirebaseAuth.instance.currentUser == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  static const titleSize = 30.0;
  static const barHeight = 60.0;
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
              Icons.cable_sharp,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ActivityInfo()));
            },
          ),
          IconButton(
              color: WanTheme.colors.grey,
              icon: Icon(
                Icons.account_circle_outlined,
              ),
              onPressed: () {
                checkSignedIn(context);
              }),
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
