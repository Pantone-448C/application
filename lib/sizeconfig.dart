import 'package:flutter/widgets.dart';

class SizeConfig {
  late MediaQueryData _mediaQueryData;
  late double w;
  late double h;
  late double wPc;
  late double hPc;

  SizeConfig(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    w = _mediaQueryData.size.width;
    h = _mediaQueryData.size.height;
    hPc = h / 100;
    wPc = w / 100;
  }
}