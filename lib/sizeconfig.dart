import 'package:flutter/widgets.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double w;
  static late double h;
  static late double hPc;
  static late double vPc;

  SizeConfig(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    w = _mediaQueryData.size.width;
    h = _mediaQueryData.size.height;
    hPc = w / 100;
    vPc = h / 100;
  }
}