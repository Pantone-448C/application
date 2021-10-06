import 'package:application/apptheme.dart';
import 'package:application/components/activity_summary_item_small.dart';
import 'package:application/models/activity.dart';
import 'package:application/models/wanderlist.dart';
import 'package:application/repositories/wanderlist/wanderlist_repository.dart';
import 'package:application/wanderlist/cubit/wanderlist_cubit.dart';
import 'package:application/wanderlist/cubit/wanderlist_state.dart';
import 'package:application/wanderlist/view/edit_wanderlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewWanderlistPage extends StatelessWidget {
  ViewWanderlistPage(this.wanderlist);

  final Wanderlist wanderlist;

  _onEditPress(BuildContext context) {
    context.read<WanderlistCubit>().startEdit(wanderlist);
  }

  _onBackPress(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _TopRow(wanderlist.name, _onEditPress),
            Padding(padding: EdgeInsets.only(top: 10)),
            _UneditableActivityList(wanderlist.activities),
          ],
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  _AppBar();

  static const barHeight = WanTheme.TITLEBAR_HEIGHT;
  @override
  Size get preferredSize => Size.fromHeight(barHeight);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WanderlistCubit, WanderlistState>(
      builder: (context, state) {
        return Container(
          child: SafeArea(
            child: AppBar(
              backgroundColor: Colors.white12,
              foregroundColor: Colors.black,
              elevation: 0,
              actions: [],
            ),
          ),
        );
      },
      listener: (context, state) => {},
    );
  }
}

class _TopRow extends StatelessWidget {
  _TopRow(this.name, this.edit);

  final String name;
  final Function(BuildContext) edit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name,
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontFamily: 'Inter',
          ),
        ),
        Padding(padding: EdgeInsets.only(left: 10)),
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              color: WanTheme.colors.pink,
              borderRadius: BorderRadius.circular(10.0)),
          child: IconButton(
            iconSize: 15,
            onPressed: () => edit(context),
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _UneditableActivityList extends StatelessWidget {
  _UneditableActivityList(this.activities);

  final List<ActivityDetails> activities;

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return _EmptyActivityList();
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0), color: Colors.white),
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return ActivitySummaryItemSmall(
            activity: activities[index],
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

class _EmptyActivityList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WanderlistCubit, WanderlistState>(
      builder: (context, state) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "There's nothing here yet!",
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
            Padding(padding: EdgeInsets.only(top: 15)),
            Container(
              decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(15.0)),
              child: TextButton(
                onPressed: () {
                  if (state is Viewing) {
                    context.read<WanderlistCubit>().startEdit(state.wanderlist);
                  }
                },
                child: Text(
                  "Add Activities",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ]),
        );
      },
      listener: (context, state) {},
    );
  }
}
