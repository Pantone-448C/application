import 'package:application/components/searchfield.dart';
import 'package:application/components/wanderlist_summary_item.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:application/repositories/user/user_repository.dart';
import 'package:application/repositories/wanderlist/wanderlist_repository.dart';
import 'package:application/userwanderlists/cubit/userwanderlists_cubit.dart';
import 'package:application/userwanderlists/cubit/userwanderlists_state.dart';
import 'package:application/userwanderlists/widgets/new_wanderlist_dialog.dart';
import 'package:application/wanderlist/view/view_wanderlist.dart';
import 'package:application/wanderlist/view/wanderlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../apptheme.dart';
import '../cubit/userwanderlists_cubit.dart';
import '../cubit/userwanderlists_state.dart';

class UserWanderlists extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserWanderlistsCubit(
        UserRepository(),
        WanderlistRepository()),
      child: _UserWanderlistsContainer(),
    );
  }
}

class _UserWanderlistsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserWanderlistsCubit, UserWanderlistsState>(
      buildWhen: (p, s) => p != s,
      builder: (context, state) {
        if (state is UserWanderlistsLoaded) {
          return _WanderlistsView(wanderlists: state.wanderlists,
            cubloc: BlocProvider.of<UserWanderlistsCubit>(context),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class _WanderlistsView extends StatelessWidget {
  final wanderlists;
  final cubloc;

  const _WanderlistsView({Key? key, this.wanderlists, this.cubloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: () {
          showDialog(
              context: context,
              builder: (context) => NewWanderlistDialog(cubloc));
        },
          backgroundColor: WanTheme.colors.pink,
          foregroundColor: WanTheme.colors.white,
          child: const Icon(Icons.add),
        ),
        body: ReorderableListView(
            header: Padding(
              // search bar
              padding: EdgeInsets.only(left: WanTheme.CARD_PADDING, right: WanTheme.CARD_PADDING,
                  top: MediaQuery.of(context).padding.top + 2 * WanTheme.CARD_PADDING, bottom: 2 * WanTheme.CARD_PADDING),
              child: TextField(
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    context.read<UserWanderlistsCubit>().filter_search(value);
                  },
                  decoration: SearchField.defaultDecoration.copyWith(
                    hintText: "Search Your Wanderlists",
                  )
              ),
            ),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: const EdgeInsets.all(WanTheme.CARD_PADDING),
            physics: WanTheme.scrollPhysics,
            onReorder: (int o, int n) {
              BlocProvider.of<UserWanderlistsCubit>(context).swap(o, n);
            },
            children: [
              for (int index = 0; index < wanderlists.length; index++)
                _TappableWanderlistCard(
                    Key('$index'), wanderlists[index])
            ]));
  }
}

class _TappableWanderlistCard extends StatelessWidget {
  _TappableWanderlistCard(this.key, this.userWanderlist);

  final Key key;
  final UserWanderlist userWanderlist;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) => WanderlistPage(userWanderlist),
        ),
      ),
      child: Container(
          margin: EdgeInsets.only(bottom: WanTheme.CARD_PADDING),
          key: ValueKey(userWanderlist.wanderlist.hashCode),
          child: WanderlistSummaryItem(
            imageUrl: userWanderlist.wanderlist.icon,
            authorName: userWanderlist.wanderlist.creatorName,
            listName: userWanderlist.wanderlist.name,
            numCompletedItems: userWanderlist.completedActivities.length,
            numTotalItems: userWanderlist.wanderlist.activities.length,
          )),
    );
  }
}

class _CreateWanderlistButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserWanderlistsCubit cubit = BlocProvider.of<UserWanderlistsCubit>(context);
    return Container(
      decoration: BoxDecoration(
          color: Colors.pink, borderRadius: BorderRadius.circular(15.0)),
      child: TextButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => NewWanderlistDialog(cubit));
        },
        child: Text(
          "Create Wanderlist",
          style: TextStyle(
            fontFamily: "Inter",
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class UserWanderlistsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: UserWanderlists(),
    );
  }
}
