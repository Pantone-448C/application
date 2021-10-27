import 'package:application/apptheme.dart';
import 'package:application/components/activity_summary_item_small.dart';
import 'package:application/pages/home/cubit/user_cubit.dart';
import 'package:application/pages/home/widgets/pinned_wanderlists.dart';
import 'package:application/pages/home/widgets/reward_info.dart';
import 'package:application/pages/home/widgets/wanderlists_list_view.dart';
import 'package:application/pages/userwanderlists/view/userwanderlists.dart';
import 'package:application/models/activity.dart';
import 'package:application/repositories/activity/rest_activity_repository.dart';
import 'package:application/repositories/user/rest_user_repository.dart';
import 'package:application/sizeconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../titlebar.dart';

const int HOME_PAGE = 0;
const int SEARCH_PAGE = 1;
const int QR_PAGE = 2;
const int WANDERLIST_PAGE = 3;

Widget _emptyOrFilledHomePage(numWanderlists, gotoWanderlistsPage) {
  if (numWanderlists > 0) {
    return _FilledHomePage(gotoWanderlistsPage);
  }
  return _EmptyHomePage(gotoWanderlistsPage);
}

class _HomePage extends StatelessWidget {

  _HomePage(this.gotoWanderlistsPage);

  final Function(int) gotoWanderlistsPage;

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

  final Function(int) gotoWanderlistsPage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit(RestUserRepository(), RestActivityRepository()),

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

class _ActivityRecommendationList extends StatelessWidget {

  final List<ActivityDetails> activities;

  const _ActivityRecommendationList({Key? key, required this.activities}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: Container(
          decoration: BoxDecoration(
              color: WanTheme.colors.white,
              borderRadius:
              BorderRadius.all(Radius.circular(WanTheme.CARD_CORNER_RADIUS))),
          padding: EdgeInsets.all(8),
          child: Column(children: [
            RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child: Container(),
                  ),
                  TextSpan(
                    text: "Recommended Activities",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ],
              ),
            ),
            Container(height: 8),
            for (var activity in activities)
              ActivitySummaryItemSmall(activity: activity,
                smallIcon: true,
              )
          ])
      ),
    );

  }

}

/// The standard home page with trip info and a list of wanderlists.
/// The only way to get to this state is to have loaded user data and
/// the ui showing > 0 wanderlists.
class _FilledHomePage extends StatelessWidget {
  _FilledHomePage(this.gotoWanderlistsPage);

  final Function(int) gotoWanderlistsPage;

  Widget _homepageItems(BuildContext context, UserLoaded state) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    double tripInfoHeight = 130;
    double viewPortHeight = MediaQuery.of(context).size.height - 160;
    double wanderlistHeight = height - tripInfoHeight;

    return Column(
      children: <Widget>[
        Container(
          height: viewPortHeight,
          child: ListView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
              if (state.recommendedActivities.length > 0) Padding(padding: EdgeInsets.only(top: 20.0)),
              if (state.recommendedActivities.length > 0)  _ActivityRecommendationList(activities: state.recommendedActivities),
              Padding(padding: EdgeInsets.only(top: 20.0)),
              _ExploreButton(() => gotoWanderlistsPage(SEARCH_PAGE), "Explore Activities"),
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
              child: RewardInfo(
                  width,
                  height,
                  state.points,
                  state.pointsUntilReward,
                  state.nextRewardTotalPoints,
                  state.percentageUntilReward,
            state.numRewards,
          ));
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

class _ExploreButton extends StatelessWidget {
  _ExploreButton (this.gotoPage, this.text);

  final Function() gotoPage;
  final String text;

  static const Radius corner = Radius.circular(WanTheme.CARD_CORNER_RADIUS);

  Widget _background(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: corner,
              bottomRight: corner,
            ),
            color: WanTheme.colors.white,
          ),
        ),
        Container(
          height: 25,
        ),
      ],
    );
  }

  Widget _button(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:[ Expanded (child: Padding(padding: EdgeInsets.all(8),
        child: Material (
          color: WanTheme.colors.pink,
            shadowColor: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.all(Radius.circular(WanTheme.CARD_CORNER_RADIUS)),
            child: InkWell (
        splashColor: WanTheme.colors.pink,
        borderRadius: BorderRadius.all(
          Radius.circular(WanTheme.BUTTON_CORNER_RADIUS),
        ),
        onTap : () => gotoPage(),
        child:  Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Center (child: Text(
            text,
              style: Theme.of(context).textTheme.headline3!.copyWith(color: Colors.white),
          ))),
      ))),
    )]);
  }

  @override
  Widget build(BuildContext context) {
    return _button(context);
  }
}

