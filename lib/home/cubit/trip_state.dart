part of 'trip_cubit.dart';

abstract class TripState {
  const TripState();
}

class TripInitial implements TripState {
  const TripInitial();
}

class TripLoading implements TripState {
  const TripLoading();
}

class TripLoaded extends Equatable implements TripState {
  const TripLoaded(this.numWanderlists, this.percentageComplete, this.points,
      this.wanderlists);

  final int numWanderlists;
  final int percentageComplete;
  final int points;
  final List<UserWanderlist> wanderlists;

  @override
  List<Object?> get props =>
      [numWanderlists, percentageComplete, points, wanderlists];

  TripLoaded copyWith(
      {int? numWanderlists,
      int? percentageComplete,
      int? points,
      List<UserWanderlist>? wanderlists}) {
    return TripLoaded(
        numWanderlists ?? this.numWanderlists,
        percentageComplete ?? this.percentageComplete,
        points ?? this.points,
        wanderlists ?? this.wanderlists);
  }
}
