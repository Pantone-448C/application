import 'dart:math' as math;

import 'package:application/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

class RewardCard extends StatelessWidget {
  RewardCard(
    this.name,
    this.iconURL,
    this.offer,
    this.location,
    this.redeemed,
    this.onPress,
  );

  final String name;
  final String iconURL;
  final String offer;
  final String location;
  final bool redeemed;
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onPress,
      child: Ink(
        decoration: BoxDecoration(
          color: WanTheme.colors.white,
          borderRadius: BorderRadius.circular(WanTheme.CARD_CORNER_RADIUS),
        ),
        child: ClipRect(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: 340, maxHeight: 110),
                child: Row(
                  children: [
                    _buildRewardIcon(),
                    CustomPaint(painter: _DashPathPainter()),
                    _buildRewardDetails(),
                  ],
                ),
              ),
              Visibility(
                visible: redeemed,
                child: Transform.rotate(
                  angle: math.pi / 4,
                  child: Container(
                    width: 400,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: redeemed,
                child: Transform.rotate(
                  angle: math.pi / 4,
                  child: Text(
                    "Redeemed!",
                    style: TextStyle(
                      fontFamily: "inter",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRewardIcon() {
    return Container(
      margin: EdgeInsets.all(8.0),
      constraints: BoxConstraints(
        maxHeight: 80,
        maxWidth: 80,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Image container
              Container(
                constraints: BoxConstraints(
                  maxHeight: 80,
                  maxWidth: 80,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: NetworkImage(this.iconURL),
                  ),
                ),
              ),
              // Linear gradient container going from black at the bottom to
              // completely transparent at the top
              Container(
                constraints: BoxConstraints(
                  maxHeight: 80,
                  maxWidth: 80,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.0),
                      Colors.black.withOpacity(0.5),
                    ],
                    stops: [0.0, 1.0],
                  ),
                ),
              ),
              // Text with padding around each side
              Container(
                padding: const EdgeInsets.all(8.0),
                constraints: BoxConstraints(maxWidth: 95),
                child: Text(
                  this.name,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: WanTheme.colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRewardDetails() {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Tap to Redeem!",
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 4.0)),
            _buildOfferPill(),
            Padding(padding: EdgeInsets.only(bottom: 4.0)),
            // Text(
            //   this.location,
            //   style: TextStyle(fontFamily: "Inter", fontSize: 14),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferPill() {
    return Container(
      constraints: BoxConstraints(
        minWidth: 130,
        minHeight: 40,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: WanTheme.colors.bgOrange,
      ),
      padding: EdgeInsets.all(4.0),
      child: Column(
        // This Column is a hacky way to center the text vertically, without
        // taking up the entire width of the column and causing the pill to be
        // too wide.
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            this.offer,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: WanTheme.colors.orange,
              fontFamily: "Inter",
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashPathPainter extends CustomPainter {
  final Paint black = Paint()
    ..color = WanTheme.colors.pink
    ..strokeWidth = 1.0
    ..style = PaintingStyle.stroke;

  final Path p = Path()
    ..moveTo(0.0, -45.0)
    ..lineTo(0.0, 45.0);

  @override
  bool shouldRepaint(_DashPathPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      dashPath(
        p,
        dashArray: CircularIntervalList<double>(
          <double>[10.0, 5.0],
        ),
      ),
      black,
    );
  }
}
