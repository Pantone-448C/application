import 'package:application/activity/cubit/add_to_cubit.dart';
import 'package:application/activity/cubit/add_to_state.dart';
import 'package:application/components/list_of_wanderlists.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:application/models/wanderlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/**
 * Page that appears when user clicks the "add to wanderlist" button on an
 * activity page
 */
class AddActivityPage extends StatelessWidget {
  const AddActivityPage(this.id, {Key? key}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityAddCubit, ActivityAddState>(
      builder: (context, state) {
        if (state is ActivityAddLoaded) {
          return ListOfWanderlists(
            wanderlists: state.wanderlists,
            readOnly: true,
            onWanderlistTap: (Wanderlist wanderlist) {
              context
                  .read<ActivityAddCubit>()
                  .addActivityToWanderlist(wanderlist);
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
