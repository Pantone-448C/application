import 'package:application/apptheme.dart';
import 'package:application/home/cubit/user_cubit.dart';
import 'package:application/home/widgets/pinned_wanderlists.dart';
import 'package:application/home/widgets/reward_info.dart';
import 'package:application/home/widgets/wanderlists_list_view.dart';
import 'package:application/repositories/user/good_user_repository.dart';
import 'package:application/sizeconfig.dart';
import 'package:application/userwanderlists/view/userwanderlists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../titlebar.dart';

Widget _emptyOrFilledHomePage(numWanderlists, gotoWanderlistsPage) {
  if (numWanderlists > 0) {
    return _FilledHomePage(gotoWanderlistsPage);
  }
  return _EmptyHomePage(gotoWanderlistsPage);
}

class _HomePage extends StatelessWidget {

  _HomePage(this.gotoWanderlistsPage);

  final Function() gotoWanderlistsPage;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is UserInitial) {
          return Text("Error!");
        } else if (state is UserLoading) {
          return Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        } else if (state is UserLoaded) {
          return RefreshIndicator(
            onRefresh: () => context.read<UserCubit>().getTripInfo(),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                ListView(),
                _FilledHomePage(gotoWanderlistsPage),
              ],
            ),
          );
        }

        return Text("Error!");
      },
      buildWhen: (current, previous) {
        return true;
      },
    );
  }

}


class HomePage extends StatelessWidget {

  HomePage(this.gotoWanderlistsPage);

  final Function() gotoWanderlistsPage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit(GoodUserRepository()),

      child: Scaffold (
        appBar: Titlebar(),
        body: _HomePage(gotoWanderlistsPage)
      )
    );
  }
}

/// An empty home page with a button asking the user to add wanderlists
class _EmptyHomePage extends StatelessWidget {
  _EmptyHomePage(this.gotoWanderlistsPage);

  final Function() gotoWanderlistsPage;

  @override
  Widget build(BuildContext context) {
    SizeConfig sz = SizeConfig(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "(Hmm... Your itinerary is empty!)",
          style:
              TextStyle(fontSize: 18, color: Colors.grey, fontFamily: 'Inter'),
        ),
        SizedBox(height: 25),
        Container(
          height: 50,
          width: sz.wPc * 70,
          decoration: BoxDecoration(
              color: WanTheme.colors.pink,
              borderRadius: BorderRadius.circular(20)),
          child: TextButton(
            onPressed: () => gotoWanderlistsPage(),
            child: Text(
              "Go to your Wanderlists",
              style: TextStyle(
                  fontSize: 18,
                  color: WanTheme.colors.white,
                  fontFamily: 'Inter'),
            ),
          ),
        ),
      ],
    );
  }
}

/// The standard home page with trip info and a list of wanderlists.
/// The only way to get to this state is to have loaded user data and
/// the ui showing > 0 wanderlists.
class _FilledHomePage extends StatelessWidget {
  _FilledHomePage(this.gotoWanderlistsPage);

  final Function() gotoWanderlistsPage;

  Column _homepageItems(BuildContext context, UserLoaded state) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    double tripInfoHeight = 130;
    double wanderlistHeight = height - tripInfoHeight;

    return Column(
      children: <Widget>[
        Container(
          // height: SizeConfig(context).h,
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                child: _TripInfo(width, tripInfoHeight),
              ),
              Padding(padding: EdgeInsets.only(top: 20.0)),
              Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: PinnedWanderlists(
                  state.pinnedWanderlists,
                  gotoWanderlistsPage,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is UserLoaded) {
          return _homepageItems(context, state);
        } else {
          return Container();
        }

        return Container();
      },
    );
  }
}

class _TripInfo extends StatelessWidget {
  final double width;
  final double height;

  _TripInfo(this.width, this.height);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is UserInitial) {
          return CircularProgressIndicator();
        } else if (state is UserLoading) {
          return CircularProgressIndicator();
        } else if (state is UserLoaded) {
          return Container(
              child: RewardInfo(width, height, 442, 558, 1000, 442 / 1000));
        }

        return Container(child: Text("Error!"));
      },
    );
  }
}

class _Wanderlists extends StatelessWidget {
  final double width;
  final double height;

  _Wanderlists(this.width, this.height);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is UserInitial) {
          return CircularProgressIndicator();
        } else if (state is UserLoading) {
          return CircularProgressIndicator();
        } else if (state is UserLoaded) {
          return Container(
              child: Column(children: [
            Container(
                width: width,
                alignment: Alignment.centerLeft,
                child: Text("Wanderlists", style: TextStyle(fontSize: 24))),
            //WanderlistsListView(width, height, state.wanderlists)
          ]));
        }

        return Container(child: Text("Error!"));
      },
    );
  }
}
