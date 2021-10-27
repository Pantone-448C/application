import 'package:application/models/reward.dart';

abstract class RewardsListState {}

class RewardsListInitial extends RewardsListState {}

class RewardsListLoading extends RewardsListState {}

class RewardsListLoaded extends RewardsListState {
  RewardsListLoaded(this.rewards);

  final List<Reward> rewards;
}
