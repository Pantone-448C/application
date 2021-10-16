import 'package:application/components/list_of_wanderlists.dart';
import 'package:application/components/searchfield.dart';
import 'package:application/components/wanderlist_summary_item.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:application/models/wanderlist.dart';
import 'package:application/repositories/user/rest_user_repository.dart';
import 'package:application/repositories/wanderlist/rest_wanderlist_repository.dart';
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
      create: (context) => UserWanderlistsCubit( RestUserRepository(),
        RestWanderlistRepository()),
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
          return _WanderlistsView(
            wanderlists: state.wanderlists,
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

  const _WanderlistsView({Key? key, this.wanderlists, this.cubloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => NewWanderlistDialog(cubloc));
          },
          backgroundColor: WanTheme.colors.pink,
          foregroundColor: WanTheme.colors.white,
          child: const Icon(Icons.add),
        ),
        body: BlocBuilder<UserWanderlistsCubit, UserWanderlistsState>(
          builder: (context, state) {
            if (state is UserWanderlistsLoaded) {
              print(state.wanderlists);
              return ListOfWanderlists(
                readOnly: false,
                wanderlists: state.wanderlists,
                onReorder: (int original, int next) {
                  context.read<UserWanderlistsCubit>().swap(original, next);
                },
                onWanderlistTap: (UserWanderlist wanderlist) => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => WanderlistPage(wanderlist),
                  ),
                ),
                onPinTap: (UserWanderlist wanderlist) {
                  context.read<UserWanderlistsCubit>().flipPin(wanderlist);
                },
              );
            } else {
              return Container();
            }
          },
        ));
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
