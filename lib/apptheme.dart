import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

ThemeData theme = ThemeData (
    primarySwatch: Colors.pink,
    fontFamily: "inter",


    textTheme: const TextTheme(
        headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),

        //subtitle1: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        //subtitle2: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        button : TextStyle(fontSize: 14),
        caption: TextStyle(fontSize: 14, fontWeight: FontWeight.w200),

        bodyText1: TextStyle(fontSize: 14.0),
        // ...
        bodyText2: TextStyle(fontSize: 14.0),
    ),

);

