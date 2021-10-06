import 'dart:io';

import 'package:application/activity/cubit/add_to_cubit.dart';
import 'package:application/activity/cubit/add_to_state.dart';
import 'package:application/components/list_of_wanderlists.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:application/models/wanderlist.dart';
import 'package:application/repositories/activity/activity_repository.dart';
import 'package:application/repositories/user/user_repository.dart';
import 'package:application/repositories/wanderlist/wanderlist_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      create: (context) => ActivityAddCubit(UserRepository(),
          WanderlistRepository(), ActivityRepository(), activityId),
      child: BlocBuilder<ActivityAddCubit, ActivityAddState>(
        builder: (context, state) {
          if (state is ActivityAddLoaded) {
            return Scaffold(
              body: ListOfWanderlists(
                wanderlists: state.wanderlists,
                readOnly: true,
                onWanderlistTap: (Wanderlist wanderlist) {
                  context
                      .read<ActivityAddCubit>()
                      .addActivityToWanderlist(wanderlist);

                  Navigator.pop(context);
                },
              ),
            );
          } else {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
