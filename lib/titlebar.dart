
import 'package:application/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Titlebar extends StatelessWidget implements PreferredSizeWidget {
  static const titleSize = 30.0;
  static const barHeight= 60.0;
  @override
  Size get preferredSize => Size.fromHeight(barHeight);
  @override
  Widget build(BuildContext context) {
    /* Transparent status bar on android -- not sure about apple */
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: WanderlistColors.white,
        statusBarIconBrightness: Brightness.dark,
      )
    );
    /* Ignore notch and status bar */
    return Container(
      child: SafeArea(
        child: AppBar(
          title: Text(
            'wanderlist',
            style: TextStyle(
              color: WanderlistColors.pink,
              fontFamily: 'Pacifico',
              fontSize: titleSize,
            )
          ),
          backgroundColor: WanderlistColors.white,
          elevation: 0,
        )
      ),
    );
  }
}