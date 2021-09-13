import 'package:flutter/material.dart';

class SmallSquareImage extends StatelessWidget {
  final double parentWidth;
  final double parentHeight;
  final ImageProvider image;

  static const double CORNER_RADIUS = 4.0;

  SmallSquareImage(this.parentWidth, this.parentHeight, this.image);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(CORNER_RADIUS)),
              image: DecorationImage(
                fit: BoxFit.fitHeight,
                alignment: FractionalOffset.topCenter,
                image: this.image,
              )),
        ),
      ),
    );
  }
}
