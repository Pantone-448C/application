import 'package:application/home/widgets/detailed_wanderlist_summary.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:flutter/material.dart';

class WanderlistsListView extends StatelessWidget {
  final double width;
  final double height;
  final List<UserWanderlist> userWanderlists;

  const WanderlistsListView(this.width, this.height, this.userWanderlists);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: this.height,
        child: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  height: 145,
                  child: DetailedWanderlistSummary(
                      370, // remove bad hard-coded value
                      145, // remove bad hard-coded value
                      this
                          .userWanderlists[index]
                          .wanderlist
                          .loadedActivities[0],
                      this.userWanderlists[index]));
            },
            separatorBuilder: (BuildContext context, int index) => Divider(
                color:
                    Colors.white10), // change this to be less of a workaround
            itemCount: userWanderlists.length));
  }
}
