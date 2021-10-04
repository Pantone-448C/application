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
  const TripLoaded(this.points, this.pointsUntilReward,
      this.nextRewardTotalPoints, this.percentageUntilReward);

  final int points;
  final int pointsUntilReward;
  final int nextRewardTotalPoints;
  final double percentageUntilReward;

  @override
  List<Object?> get props =>
      [points, pointsUntilReward, nextRewardTotalPoints, percentageUntilReward];
}
