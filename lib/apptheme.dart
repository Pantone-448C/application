import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:math';
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

  var heading = TextStyle(fontSize: 18);
  var cardTitle = TextStyle(fontSize: 14);
  var cardBody = TextStyle(color: WanColors().grey, fontSize: 12);

  var loginButton = TextStyle(
    color: Colors.white,
    fontSize: 25,
  );

  var signupButton = TextStyle(color: WanTheme.colors.pink, fontSize: 15);
}

// Source
// https://gist.github.com/moritzmorgenroth/5602102d855efde2d686b0c7c5a095ad
MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: tintColor(color, 0.5),
    100: tintColor(color, 0.4),
    200: tintColor(color, 0.3),
    300: tintColor(color, 0.2),
    400: tintColor(color, 0.1),
    500: tintColor(color, 0),
    600: tintColor(color, -0.1),
    700: tintColor(color, -0.2),
    800: tintColor(color, -0.3),
    900: tintColor(color, -0.4),
  });
}

int tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

Color tintColor(Color color, double factor) => Color.fromRGBO(
    tintValue(color.red, factor),
    tintValue(color.green, factor),
    tintValue(color.blue, factor),
    1);

class WanTheme {
  static const double CARD_CORNER_RADIUS = 15.0;
  static const double THUMB_CORNER_RADIUS = 5.0;
  static const double BUTTON_CORNER_RADIUS = 10.0;
  static const double BORDER_RADIUS = 15.0;
  static const double PAGE_MARGIN = 20;
  static const double CARD_PADDING = 8;
  static const double TITLEBAR_HEIGHT = 60;

  static ColorScheme defaultCols = ColorScheme(
    background: Colors.white,
    brightness: Brightness.light,
    primary: WanColors().pink,
    onPrimary: Colors.white,
    primaryVariant: WanColors().bgOrange,
    surface: WanColors().offWhite,
    onBackground: Colors.black,
    secondary: WanColors().bgOrange,
    onSecondary: WanColors().orange,
    secondaryVariant: WanColors().bgOrange,
    onSurface: Colors.black,
    error: Colors.red,
    onError: Colors.white,
  );

  static ThemeData materialTheme = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
    ),
    primarySwatch: generateMaterialColor(WanColors().pink),
    colorScheme: defaultCols,
    iconTheme: IconThemeData(color: WanColors().pink),
    primaryIconTheme: IconThemeData(color: WanColors().pink),
    accentIconTheme: IconThemeData(color: WanColors().pink),
    fontFamily: "inter",
    textTheme: const TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      headline2: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      headline3: TextStyle(fontSize: 24.0, color: Colors.black),
      headline4: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),

      //subtitle1: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      //subtitle2: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      button: TextStyle(fontSize: 14),
      caption: TextStyle(fontSize: 12),

      bodyText1: TextStyle(fontSize: 14.0, color: Colors.grey),
      // ...
      bodyText2: TextStyle(fontSize: 12.0, color: Colors.black),
    ),
  );

  static WanTextTheme text = WanTextTheme();
  static WanColors colors = WanColors();
}

class WanColors {
  var pink = Color(0xFFFE4165);
  var grey = Color.fromRGBO(0x42, 0x42, 0x42, 0.9);
  var lightGrey = Color(0xFFEEEEEE);
  var offWhite = Color.fromRGBO(0xF6, 0xF6, 0xF6, 1);
  var bgOrange = Color.fromRGBO(0xFF, 0xDC, 0xC1, 1);
  var orange = Color.fromRGBO(0xFF, 0x83, 0x26, 1);
  var white = Colors.white;
  final LinearGradient pinkOrangeGradient = LinearGradient(
    colors: <Color>[
      Color(0xFFFF8326),
      Color(0xFFFF2D55),
    ],
  );
}
