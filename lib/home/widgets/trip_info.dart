import 'package:application/models/trip.dart';
import 'package:flutter/material.dart';

class TripInfo extends StatelessWidget {
  final double width;
  final double height;
  final String name;
  final int numWanderlists;
  final int percentageComplete;
  final int points;

  static const double CORNER_RADIUS = 15.0;

  TripInfo(this.width, this.height, this.name, this.numWanderlists,
      this.percentageComplete, this.points);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: this.width,
        height: this.height,
        padding: EdgeInsets.fromLTRB(
            width / 25, height / 7.5, width / 25, height / 7.5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(CORNER_RADIUS))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 15,
              child: _Details(this.name, this.numWanderlists,
                this.percentageComplete, this.points)),
            Spacer(flex: 1),
            Expanded(flex: 1, child: _ProgressBar(this.percentageComplete))
          ],
        ));
  }
}

class _Details extends StatelessWidget {
  final String name;
  final int numWanderlists;
  final int percentageComplete;
  final int points;

  _Details(
      this.name, this.numWanderlists, this.percentageComplete, this.points);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 40,
            child: _LeftDetails(this.name, this.numWanderlists, this.points)
          ),
          Expanded(
            flex: 14,
            child: _RightDetails(this.percentageComplete)
          ),
        ]
      )
    );
  }
}

class _LeftDetails extends StatelessWidget {
  final String name;
  final int numWanderlists;
  final int points;

  _LeftDetails(this.name, this.numWanderlists, this.points);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            this.name,
            style: TextStyle(fontSize: 24),
          ),
          Text("this trip", style: TextStyle(fontSize: 14, color: Colors.grey))
        ]),
        Row(children: [
          Expanded(
            flex: 4, child: _BigSmallText(this.points.toString(), " points")
          ),
          Spacer(flex: 1),
          Expanded(
            flex: 4,
            child: _BigSmallText(
              this.numWanderlists.toString(), " wanderlists"
            )
          ),
          Spacer(flex: 3),
        ])
      ],
    ));
  }
}

// TODO: Fix the alignment of this text - it won't work for some reason.
class _RightDetails extends StatelessWidget {
  final int percentageComplete;

  _RightDetails(this.percentageComplete);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(this.percentageComplete.toString(),
                style: TextStyle(fontSize: 48)),
            Text("%", style: TextStyle(fontSize: 20, color: Colors.grey))
          ])
    ]));
  }
}

class _BigSmallText extends StatelessWidget {
  final String bigText;
  final String smallText;

  _BigSmallText(this.bigText, this.smallText);

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(this.bigText, style: TextStyle(fontSize: 20)),
          Text(this.smallText,
              style: TextStyle(fontSize: 12, color: Colors.grey))
        ]);
  }
}

class _ProgressBar extends StatelessWidget {
  final percentageComplete;

  _ProgressBar(this.percentageComplete);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 384, height: 5, child: LinearProgressIndicator(value: 0.66));
  }
}
