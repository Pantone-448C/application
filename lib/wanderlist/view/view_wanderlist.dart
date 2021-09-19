import 'package:application/apptheme.dart';
import 'package:application/components/activity_summary_item_small.dart';
import 'package:application/models/activity.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:application/repositories/wanderlist/wanderlist_repository.dart';
import 'package:application/wanderlist/cubit/wanderlist_cubit.dart';
import 'package:application/wanderlist/cubit/wanderlist_state.dart';
import 'package:application/wanderlist/view/edit_wanderlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewWanderlistPage extends StatelessWidget {
  ViewWanderlistPage(this.userWanderlist);

  final UserWanderlist userWanderlist;

  _onEditPress(BuildContext context) {
    context.read<WanderlistCubit>().startEdit(userWanderlist);
  }

  _onBackPress(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _TopRow(userWanderlist.wanderlist.name, _onEditPress, _onBackPress),
        _UneditableActivityList(userWanderlist.wanderlist.activities,
            userWanderlist.completedActivities),
      ],
    );
  }
}

class _TopRow extends StatelessWidget {
  _TopRow(this.name, this.edit, this.back);

  final String name;
  final Function(BuildContext) edit;
  final Function(BuildContext) back;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WanderlistCubit, WanderlistState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => back(context),
              child:
                  Text("back", style: TextStyle(color: WanTheme.colors.pink)),
            ),
            Text(name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Inter',
                )),
            TextButton(
              onPressed: () => edit(context),
              child:
                  Text("edit", style: TextStyle(color: WanTheme.colors.pink)),
            ),
          ],
        );
      },
      listener: (context, state) => {},
    );
  }
}

class _UneditableActivityList extends StatelessWidget {
  _UneditableActivityList(this.activities, this.completedActivities);

  final List<ActivityDetails> activities;
  final List<ActivityDetails> completedActivities;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0), color: Colors.white),
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return ActivitySummaryItemSmall(
            activityName: activities[index].name,
            activityDescription: activities[index].about,
            imageUrl: activities[index].imageUrl,
            smallIcon: true,
          );
        },
        itemCount: activities.length,
        // separatorBuilder: (BuildContext context, int index) {
        //   return Divider();
        // },
      ),
    );
  }
}
