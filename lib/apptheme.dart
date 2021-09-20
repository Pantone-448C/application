import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

// These should be generic text styles, eg "label", "title", "button1", "button2"
// loginButton and signupButton are temporary to illustrate how they are used,
// because those specific widgets will be replaced soon anyway.
//
// eventually merge with colours class
class WanTextTheme {
  var logo = TextStyle(
    fontFamily: 'Pacifico',
    fontSize: 40,
    color: WanTheme.colors.pink,
  );

  var errorLabel = TextStyle(color: Colors.red);

  var cardTitle = TextStyle(fontSize: 18);
  var cardBody = TextStyle(color: Color(0x999999), fontSize: 12);

  var loginButton = TextStyle(
    color: Colors.white,
    fontSize: 25,
  );

  var signupButton = TextStyle(color: WanTheme.colors.pink, fontSize: 15);
}

class WanTheme {
  static const double CARD_CORNER_RADIUS = 15.0;

  static ThemeData materialTheme = ThemeData(
    primarySwatch: Colors.pink,
    fontFamily: "inter",
    textTheme: const TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),

      headline4: TextStyle(fontSize: 18.0, color: Colors.black),

      //subtitle1: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      //subtitle2: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      button: TextStyle(fontSize: 14),
      caption: TextStyle(fontSize: 12),

      bodyText1: TextStyle(fontSize: 14.0),
      // ...
      bodyText2: TextStyle(fontSize: 12.0, color: Colors.grey),
    ),
  );

  static WanTextTheme text = WanTextTheme();
  static WanColors colors = WanColors();
}

class WanColors {
  var pink = Color.fromRGBO(0xFF, 0x2D, 0x55, 0.9);
  var grey = Color.fromRGBO(0x42, 0x42, 0x42, 0.9);
  var offWhite = Color.fromRGBO(0xF6, 0xF6, 0xF6, 1);
  var bgOrange = Color.fromRGBO(0xFF, 0xDC, 0xC1, 1);
  var orange = Color.fromRGBO(0xFF, 0x83, 0x26, 1);
  var white = Colors.white;
}
