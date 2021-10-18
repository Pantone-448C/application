part of 'user_cubit.dart';

abstract class UserState {
  const UserState();
}

class UserInitial implements UserState {
  const UserInitial();
}

class UserLoading implements UserState {
  const UserLoading();
}

class UserLoaded extends Equatable implements UserState {
  const UserLoaded(
      this.points,
      this.pointsUntilReward,
      this.nextRewardTotalPoints,
      this.percentageUntilReward,
      this.pinnedWanderlists);

  final int points;
  final int pointsUntilReward;
  final int nextRewardTotalPoints;
  final double percentageUntilReward;
  final List<UserWanderlist> pinnedWanderlists;

  @override
  List<Object?> get props => [
        points,
        pointsUntilReward,
        nextRewardTotalPoints,
        percentageUntilReward,
        pinnedWanderlists,
      ];
}
