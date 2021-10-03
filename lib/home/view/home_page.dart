import 'package:application/apptheme.dart';
import 'package:application/home/cubit/trip_cubit.dart';
import 'package:application/home/widgets/trip_info.dart';
import 'package:application/home/widgets/wanderlists_list_view.dart';
import 'package:application/repositories/user/user_repository.dart';
import 'package:application/sizeconfig.dart';
import 'package:application/userwanderlists/view/userwanderlists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget _emptyOrFilledHomePage(numWanderlists, gotoWanderlistsPage) {
  if (numWanderlists > 0) {
    return _FilledHomePage();
  }
  return _EmptyHomePage(gotoWanderlistsPage);
}

class HomePage extends StatelessWidget {
  HomePage(this.gotoWanderlistsPage);

  final Function() gotoWanderlistsPage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TripCubit(UserRepository()),
      child: BlocConsumer<TripCubit, TripState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is TripInitial) {
            return Text("Error!");
          } else if (state is TripLoading) {
            return Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          } else if (state is TripLoaded) {
            return RefreshIndicator(
              onRefresh: () => context.read<TripCubit>().getTripInfo(),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  ListView(),
                  _emptyOrFilledHomePage(
                    state.numWanderlists,
                    gotoWanderlistsPage,
                  ),
                ],
              ),
            );
          }

          return Text("Error!");
        },
        buildWhen: (current, previous) {
          return true;
        },
      ),
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
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    double tripInfoHeight = 130;
    double wanderlistHeight = height - tripInfoHeight;

    return BlocConsumer<TripCubit, TripState>(
      listener: (context, state) {},
      builder: (context, state) {
        return
        ListView(children: <Widget>[
            Container (
              height: SizeConfig(context).h,
          padding: EdgeInsets.only(left: WanTheme.CARD_PADDING,
              right: WanTheme.CARD_PADDING),
            child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 30, bottom: 15),
              child: _TripInfo(width, tripInfoHeight),
            ),
            Container(
              child: _NextRewardsInfo(),
            ),
            Container(
              child: _Wanderlists(width, wanderlistHeight),
            ),
          ],
        ))]);
      },
    );
  }
}

class _HelloMessage extends StatelessWidget {
  final String name = "";

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripCubit, TripState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is TripLoaded) {
            return Text(
              "Hello, " + state.firstName,
            );
          } else {
            return Container();
          }
        });
  }
}

class _TripInfo extends StatelessWidget {
  final double width;
  final double height;

  _TripInfo(this.width, this.height);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripCubit, TripState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is TripInitial) {
          return CircularProgressIndicator();
        } else if (state is TripLoading) {
          return CircularProgressIndicator();
        } else if (state is TripLoaded) {
          return Container(
              child: TripInfo(width, height, state.name, state.numWanderlists,
                  state.percentageComplete, state.points));
        }

        return Container(child: Text("Error!"));
      },
    );
  }
}

class _NextRewardsInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripCubit, TripState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
            // TODO: Implement _NextRewardsInfo widgets
            );
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
    return BlocConsumer<TripCubit, TripState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is TripInitial) {
          return CircularProgressIndicator();
        } else if (state is TripLoading) {
          return CircularProgressIndicator();
        } else if (state is TripLoaded) {
          return Container(
              child: Column(children: [
            Container(
                width: width,
                alignment: Alignment.centerLeft,
                child: Text("Wanderlists", style: TextStyle(fontSize: 24))),
            WanderlistsListView(width, height, state.wanderlists)
          ]));
        }

        return Container(child: Text("Error!"));
      },
    );
  }
}
