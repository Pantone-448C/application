import 'package:application/apptheme.dart';
import 'package:application/home/widgets/unused_rewards_dropdown.dart';
import 'package:application/models/trip.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class RewardInfo extends StatelessWidget {
  RewardInfo(
    this.width,
    this.height,
    this.points,
    this.pointsUntil,
    this.rewardPoints,
    this.percentagePointsUntil,
  );

  final double width;
  final double height;
  final int points;
  final int rewardPoints;
  final int pointsUntil;
  final double percentagePointsUntil;

  static const double CORNER_RADIUS = 15.0;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _InfoPanel(
        width,
        height,
        points,
        rewardPoints,
        pointsUntil,
        percentagePointsUntil,
      ),
      UnusedRewardsDropdown(width, height / 3, 6),
    ]);
  }
}

class _InfoPanel extends StatelessWidget {
  _InfoPanel(
    this.width,
    this.height,
    this.points,
    this.pointsUntil,
    this.rewardPoints,
    this.percentagePointsUntil,
  );

  final double width;
  final double height;
  final int points;
  final int rewardPoints;
  final int pointsUntil;
  final double percentagePointsUntil;

  static const double CORNER_RADIUS = 15.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: WanTheme.colors.bgOrange,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(CORNER_RADIUS),
          topRight: Radius.circular(CORNER_RADIUS),
        ),
      ),
      child: Container(
        width: this.width,
        height: this.height,
        padding: EdgeInsets.fromLTRB(
            width / 25, height / 7.5, width / 25, height / 7.5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(WanTheme.CARD_CORNER_RADIUS),
            bottomRight: Radius.circular(WanTheme.CARD_CORNER_RADIUS),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            pointsUntilText(context, pointsUntil.toString()),
            _ProgressBar(percentagePointsUntil),
            SizedBox(
              width: width,
              child: pointsOfTotalText(
                context,
                points.toString(),
                rewardPoints.toString(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

RichText pointsUntilText(BuildContext context, String points) {
  return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      style: Theme.of(context).textTheme.headline3,
      children: [
        TextSpan(
          text: points + " points",
          style: TextStyle(
            foreground: Paint()
              ..shader = WanTheme.colors.pinkOrangeGradient.createShader(
                Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
              ),
          ),
        ),
        TextSpan(
          text: " until your next reward!",
          style: TextStyle(color: WanTheme.colors.grey),
        ),
      ],
    ),
  );
}

RichText pointsOfTotalText(
    BuildContext context, String points, String rewardPoints) {
  return RichText(
    textAlign: TextAlign.right,
    text: TextSpan(
      text: points + " / " + rewardPoints + " points",
      style: Theme.of(context).textTheme.bodyText2!.copyWith(
            color: WanTheme.colors.pink,
          ),
    ),
  );
}

class _ProgressBar extends StatelessWidget {
  final percentageComplete;

  _ProgressBar(this.percentageComplete);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 384,
      height: 5,
      child: GradientProgressIndicator(
        value: this.percentageComplete,
        gradient: WanTheme.colors.pinkOrangeGradient,
        backgroundColor: WanTheme.colors.lightGrey,
      ),
    );
  }
}
