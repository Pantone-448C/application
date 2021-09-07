import 'package:application/home/cubit/trip_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TripCubit(),
      child: Column(children: [
        Container(child: _TripInfo()),
        Container(child: _NextRewardsInfo()),
        Container(child: _Wanderlists()),
      ]),
    );
  }
}

class _TripInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripCubit, TripState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
            // TODO: Implement _TripInfo widgets
            );
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
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripCubit, TripState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
            // TODO: Implement _Wanderlists widgets
            );
      },
    );
  }
}
