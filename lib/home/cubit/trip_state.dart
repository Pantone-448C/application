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
  const TripLoaded(this.name, this.numWanderlists, this.percentageComplete,
      this.points, this.wanderlists, this.firstName);

  final String name;
  final int numWanderlists;
  final int percentageComplete;
  final int points;
  final List<UserWanderlist> wanderlists;
  final String firstName;

  @override
  List<Object?> get props =>
      [numWanderlists, percentageComplete, points, wanderlists];

  TripLoaded copyWith(
      {String? name,
      int? numWanderlists,
      int? percentageComplete,
      int? points,
      List<UserWanderlist>? wanderlists,
      String? firstName}) {
    return TripLoaded(
      name ?? this.name,
      numWanderlists ?? this.numWanderlists,
      percentageComplete ?? this.percentageComplete,
      points ?? this.points,
      wanderlists ?? this.wanderlists,
      firstName ?? this.firstName,
    );
  }
}
