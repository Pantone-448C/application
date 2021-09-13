
import 'package:application/components/wanderlist_summary_item.dart';
import 'package:application/repositories/user/user_repository.dart';
import 'package:application/userwanderlists/cubit/userwanderlists_cubit.dart';
import 'package:application/userwanderlists/cubit/userwanderlists_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/userwanderlists_cubit.dart';
import '../cubit/userwanderlists_state.dart';




class UserWanderlists extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => UserWanderlistsCubit(UserRepository()),
        child: _WanderlistsView(),
    );
  }
}

class _WanderlistsView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserWanderlistsCubit, UserWanderlistsState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is UserWanderlistsLoaded) {
            return ReorderableListView (
              header: Padding (
                // search bar
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextField(
                  keyboardType: TextInputType.text,
                  onChanged: (value) {context.read<UserWanderlistsCubit>().filter_search(value);},
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Search Your Wanderlists',
                  ),
                ),
              ),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: true,
              padding: EdgeInsets.all(8),
              physics: ClampingScrollPhysics(),
              onReorder: (int o, int n) { context.read<UserWanderlistsCubit>().swap(o,n); },
              children: [
                for (int index = 0; index < state.wanderlists.length; index++)
                  Container (
                    margin: EdgeInsets.only(bottom:8),
                   key: ValueKey(state.wanderlists[index].wanderlist.hashCode),
                    child: WanderlistSummaryItem(
                    imageUrl: state.wanderlists[index].wanderlist.icon,
                    authorName: state.wanderlists[index].wanderlist.creatorName,
                    listName:  state.wanderlists[index].wanderlist.name,
                    numCompletedItems: 10,
                    numTotalItems: 11,
                  ) )
              ]
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },

    );
  }
}

class UserWanderlistsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left:8, right:8),
      child: UserWanderlists(),
    );
  }

}

