
import 'package:application/components/wanderlist_summary_item.dart';
import 'package:application/models/userwanderlists.dart';
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

    final List<UserWanderlist> l = [
      UserWanderlist(
          userId: 0,
          numCompleted: 0,
          numTotal: 1,
          wanderlist: UserWanderlistItem (
            id: 0,
            name: "Cool Item",
            image: 'https://topost.net/deco/media/img0.png',
            creatorName: 'David Smith',
          )
      ),
      UserWanderlist(
          userId: 1,
          numCompleted: 0,
          numTotal: 1,
          wanderlist: UserWanderlistItem (
            id: 0,
            name: "Cool Item 2",
            image: 'https://topost.net/deco/media/img0.png',
            creatorName: 'David Smith',
          )
      ),
      UserWanderlist(
          userId: 0,
          numCompleted: 0,
          numTotal: 1,
          wanderlist: UserWanderlistItem (
            id: 2,
            name: "Cool Item 3",
            image: 'https://topost.net/deco/media/img0.png',
            creatorName: 'David Smith',
          )
      ),
    ];

    return BlocProvider(
        create: (context) => UserWanderlistsCubit(l),
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
          return Column(
          children: <Widget>[
            Padding (
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                keyboardType: TextInputType.text,
                onChanged: (value) {context.read<UserWanderlistsCubit>().filter_search(value);},
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Search',
                ),
              ),
            ),
            ReorderableListView (
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: EdgeInsets.all(8),
              onReorder: (int o, int n) { context.read<UserWanderlistsCubit>().swap(o,n); },
              children: [
                for (int index = 0; index < state.wanderlists.length; index++)
                  Container (
                   key: ValueKey(state.wanderlists[index].wanderlist.name),
                    child: WanderlistSummaryItem(
                    imageUrl: state.wanderlists[index].wanderlist.image,
                    authorName: state.wanderlists[index].wanderlist.creatorName,
                    listName:  state.wanderlists[index].wanderlist.name,
                    numCompletedItems: 10,
                    numTotalItems: 11,
                  ) )
              ]
          )]
          );
        } else {
          return Container();
        }
      },

    );
  }
}


