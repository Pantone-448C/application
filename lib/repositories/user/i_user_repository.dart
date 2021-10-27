import 'package:application/models/activity.dart';
import 'package:application/models/reward.dart';
import 'package:application/models/user.dart';
import 'package:application/models/user_wanderlist.dart';

abstract class IUserRepository {
  // Wanderlists
  Future<Iterable<UserWanderlist>> getActiveWanderlists();

  Future<Iterable<UserWanderlist>> getUserWanderlists();

  Future<void> updateUserWanderlists(List<UserWanderlist> list);

  Future<void> addUserWanderlist(UserWanderlist wanderlist);

  // User
  Future<UserDetails> getUserData();

  Future<Iterable<ActivityDetails>> getUserCompletedActivities();

  Future<void> updateUserData(UserDetails details);

  Future<void> updateUserCompletedActivities(List<ActivityDetails> list);

  // Rewards
  Future<Iterable<Reward>> getUserRewards();

  Future<int> getPointsForNextReward();

  Future<Reward> getRecommendedReward();

  Future<void> addReward(Reward reward);

  Future<void> updateReward(Reward reward);

  // Activity ???
  Future<ActivityDetails> getActivity(String id);
}
