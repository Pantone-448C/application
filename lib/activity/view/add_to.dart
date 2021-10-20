
import 'package:application/activity/cubit/add_to_cubit.dart';
import 'package:application/activity/cubit/add_to_state.dart';
import 'package:application/components/list_of_wanderlists.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:application/repositories/activity/rest_activity_repository.dart';
import 'package:application/repositories/user/rest_user_repository.dart';
import 'package:application/repositories/wanderlist/rest_wanderlist_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../apptheme.dart';


class _PageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<ActivityAddCubit, ActivityAddState>(
      builder: (context, state) {
        if (state is ActivityAddLoaded) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Add to Wanderlist",
              style: TextStyle(color: WanTheme.colors.pink),
              ),
            ),
            body: Column (
                children: [
                  Expanded (child: ListOfWanderlists(
              wanderlists: state.wanderlists,
              readOnly: true,
              onWanderlistTap: (UserWanderlist wanderlist) {
                context
                    .read<ActivityAddCubit>()
                    .addActivityToWanderlist(wanderlist.wanderlist);
                Navigator.pop(context);
              },
            )),
            ])
          );
        } else {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

}

/**
 * Page that appears when user clicks the "add to wanderlist" button on an
 * activity page
 */
class AddActivityPage extends StatelessWidget {
  const AddActivityPage(this.activityId, {Key? key}) : super(key: key);

  final String activityId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActivityAddCubit(RestUserRepository(),
          RestWanderlistRepository(), RestActivityRepository(), activityId),
      child: _PageBody(),
    );
  }
}
