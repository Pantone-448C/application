import 'dart:developer';

import 'package:application/models/activity.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:application/models/wanderlist.dart';
import 'package:application/repositories/activity/activity_repository.dart';
import 'package:application/repositories/user/user_repository.dart';
import 'package:application/repositories/wanderlist/wanderlist_repository.dart';
import 'package:application/wanderlist/cubit/suggestions_cubit.dart';
import 'package:application/wanderlist/cubit/wanderlist_cubit.dart';
import 'package:application/wanderlist/cubit/wanderlist_state.dart';
import 'package:application/wanderlist/view/edit_wanderlist.dart';
import 'package:application/wanderlist/view/view_wanderlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WanderlistPage extends StatelessWidget {
  WanderlistPage(this.wanderlist);

  final UserWanderlist wanderlist;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider<WanderlistCubit>(
              create: (context) => WanderlistCubit(WanderlistRepository()),
            ),
            BlocProvider<SuggestionsCubit>(
              create: (context) => SuggestionsCubit(ActivityRepository()),
            ),
          ],
          child: _PageContent(wanderlist.wanderlist),
        ),
      ),
    );
  }
}

class _PageContent extends StatelessWidget {
  _PageContent(this.wanderlist);

  final Wanderlist wanderlist;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WanderlistCubit, WanderlistState>(
      builder: (context, state) {
        if (state is Loading) {
          return CircularProgressIndicator();
        } else if (state is Viewing) {
          return ViewWanderlistPage(state.wanderlist);
        } else if (state is Editing) {
          return EditWanderlistPage(state.wanderlist);
        } else if (state is Saving) {
          return CircularProgressIndicator();
        } else if (state is Saved) {
          Navigator.of(context).pop();
        } else {
          context.read<WanderlistCubit>().loadWanderlists(wanderlist);
        }

        return CircularProgressIndicator();
      },
      listener: (context, state) {},
    );
  }
}
