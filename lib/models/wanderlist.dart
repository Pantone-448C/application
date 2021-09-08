import 'package:application/models/activity.dart';

class Wanderlist {
  Wanderlist(
    this.id,
    this.name,
    this.activities,
    this.creatorName,
  );

  int id;
  String name;
  List<ActivityDetails> activities;
  String creatorName;
}

class UserWanderlist {
  UserWanderlist(
    this.userId,
    this.numCompleted,
    this.numTotal,
    this.wanderlist,
  );

  int userId;
  int numCompleted;
  int numTotal;
  Wanderlist wanderlist;
}
