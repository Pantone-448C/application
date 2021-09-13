import 'package:application/models/activity.dart';
import 'package:application/models/wanderlist.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

@immutable
class UserWanderlist extends Equatable {
  UserWanderlist(
    this.wanderlist,
    this.completedActivities,
    this.inTrip,
    this.numCompletions,
  );

  factory UserWanderlist.fromJson(Map<String, dynamic> json) {
    Wanderlist wanderlist = Wanderlist.fromJson(json['wanderlist']);
    List<ActivityDetails> activities = [];
    if (json['completed_activities'] != null) {
      activities = json['completed_activities']
          .map<ActivityDetails>(
              (activity) => ActivityDetails.fromJson(activity))
          .toList();
    }

    return UserWanderlist(
        wanderlist, activities, json['in_trip'], json['num_completions']);
  }

  final Wanderlist wanderlist;
  final List<ActivityDetails> completedActivities;
  final bool inTrip;
  final int numCompletions;

  @override
  List<Object?> get props =>
      [wanderlist, completedActivities, inTrip, numCompletions];

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  UserWanderlist copyWith(
    Wanderlist? wanderlist,
    List<ActivityDetails>? activities,
    bool? inTrip,
    int? numCompletions,
  ) {
    return UserWanderlist(
        wanderlist ?? this.wanderlist,
        activities ?? this.completedActivities,
        inTrip ?? this.inTrip,
        numCompletions ?? this.numCompletions);
  }
}
