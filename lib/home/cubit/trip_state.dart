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
  const TripLoaded(this.numWanderlists, this.percentageComplete, this.points);

  final int numWanderlists;
  final int percentageComplete;
  final int points;
  // TODO: Also need a list of wanderlists here at some point once the
  // Wanderlist model is implemented

  @override
  List<Object?> get props => [numWanderlists, percentageComplete, points];

  TripLoaded copyWith({
    int? numWanderlists,
    int? percentageComplete,
    int? points,
  }) {
    return TripLoaded(numWanderlists ?? this.numWanderlists,
        percentageComplete ?? this.percentageComplete, points ?? this.points);
  }
}
