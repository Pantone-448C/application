import 'package:application/home/cubit/trip_cubit.dart';
import 'package:application/home/widgets/trip_info.dart';
import 'package:application/home/widgets/wanderlists_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    double tripInfoHeight = 120;
    double wanderlistHeight = height - tripInfoHeight;

    return BlocProvider(
      create: (context) => TripCubit(),
      child: Column(children: [
        Container(child: _TripInfo(width, tripInfoHeight)),
        Container(child: _NextRewardsInfo()),
        Container(child: _Wanderlists(width, wanderlistHeight)),
      ]),
    );
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
                state.percentageComplete, state.points)
            );
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
            child: Column(
              children: [
              Container(
                width: width,
                alignment: Alignment.centerLeft,
                child: Text("Wanderlists", style:TextStyle(fontSize:24))
              ),
              WanderlistsListView(width, height, state.wanderlists)])
            );
        }

        return Container(child: Text("Error!"));
      },
    );
  }
}
