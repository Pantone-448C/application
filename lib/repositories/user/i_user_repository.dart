import 'package:application/models/activity.dart';
import 'package:application/models/user.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IUserRepository {
  Future<UserDetails> getUserData();
  Future<Iterable<UserWanderlist>> getActiveWanderlists();
  Future<Iterable<UserWanderlist>> getUserWanderlists();
  Future<Iterable<ActivityDetails>> getUserCompletedActivities();
  Future<void> updateUserData(UserDetails details);
  Future<void> updateUserWanderlists(List<UserWanderlist> list);
  Future<void> updateUserCompletedActivities(List<ActivityDetails> list);
  Future<void> addUserWanderlist(UserWanderlist wanderlist);

  Future<ActivityDetails> getActivity(String id);
}
