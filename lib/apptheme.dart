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
    );

    var errorLabel = TextStyle(
        color: Colors.red
    );

    var loginButton = TextStyle(color: Colors.white, fontSize: 25);

    var signupButton = TextStyle(color: Colors.blue, fontSize: 15);
}

class WanTheme {
    ThemeData materialTheme = ThemeData (
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

    WanTextTheme text = WanTextTheme();

}


WanTheme theme = WanTheme();

