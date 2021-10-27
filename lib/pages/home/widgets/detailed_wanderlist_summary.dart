import 'package:application/components/small_square_image.dart';
import 'package:application/models/activity.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:application/pages/activity/view/activity_info.dart';
import 'package:application/pages/wanderlist/view/wanderlist.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../apptheme.dart';

class DetailedWanderlistSummary extends StatelessWidget {
  final double width;
  final double height;
  final ActivityDetails nextActivity;
  final UserWanderlist userWanderlist;

  static const double CORNER_RADIUS = 15.0;

  DetailedWanderlistSummary(
      this.width, this.height, this.nextActivity, this.userWanderlist);

  @override
  Widget build(BuildContext context) {
    String name = userWanderlist.wanderlist.name;
    int total = userWanderlist.wanderlist.activities.length;
    int completed = userWanderlist.completedActivities.length;

    return Container(
      padding: EdgeInsets.fromLTRB(
          width / 25, height / 7.5, width / 25, height / 30),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(CORNER_RADIUS))),
      child: Column(
        children: [
          GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (context) => WanderlistPage(userWanderlist))),
              child: _TopSummary(this.width, 60, name, total, completed)),
          Divider(color: Colors.grey),
          _Activity(this.width, 70, nextActivity),
          _NMoreItems(total - 1),
        ],
      ),
    );
  }
}

class _TopSummary extends StatelessWidget {
  final double width;
  final double height;
  final String wanderlistName;
  final int numTotalActivities;
  final int numCompleteActivities;

  _TopSummary(this.width, this.height, this.wanderlistName,
      this.numTotalActivities, this.numCompleteActivities);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 5,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(this.wanderlistName, style: WanTheme.text.cardTitle),
            Text(
                this.numCompleteActivities.toString() +
                    " out of " +
                    this.numTotalActivities.toString() +
                    " complete",
                style: Theme.of(context).textTheme.caption)
          ]),
          Icon(
            Icons.chevron_right_outlined,
          ),
        ]));
  }
}

// TODO: Fix this widget to make the alignment a bit closer to the figma prototype
class _Activity extends StatelessWidget {
  final double width;
  final double height;
  final ActivityDetails activity;

  const _Activity(this.width, this.height, this.activity);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 5,
        child: InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ActivityInfo(activity.id))),
          child: Container(
              alignment: Alignment.centerLeft,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        flex: 5,
                        child: SmallSquareImage(this.width, this.height,
                            CachedNetworkImageProvider(activity.imageUrl))),
                    Spacer(flex: 1),
                    Expanded(flex: 32, child: _ActivityName(activity.name)),
                  ])),
        ));
  }
}

class _ActivityName extends StatelessWidget {
  String activityName;

  _ActivityName(this.activityName);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
          flex: 100,
          child: Container(
              alignment: Alignment.centerLeft,
              child: Text(this.activityName, style: WanTheme.text.cardTitle))),
      Expanded(flex: 1, child: Divider(color: Colors.grey))
    ]);
  }
}

class _NMoreItems extends StatelessWidget {
  final int itemsLeft;

  const _NMoreItems(this.itemsLeft);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 2,
        child: Center(
            child: Text(this.itemsLeft.toString() + " more items",
                style: TextStyle(fontSize: 12, color: Colors.grey))));
  }
}
