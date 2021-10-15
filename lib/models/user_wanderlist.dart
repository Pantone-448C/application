import 'package:application/models/activity.dart';
import 'package:application/models/wanderlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

@immutable
class UserWanderlist extends Equatable {

  UserWanderlist(
    this.wanderlist,
    this.completedActivities,
    this.inTrip,
    this.numCompletions,
    this.id,
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
        wanderlist, activities, json['in_trip'], json['num_completions'], wanderlist.id);
  }

  final String id;
  final Wanderlist wanderlist;
  final List<ActivityDetails> completedActivities;
  final bool inTrip;
  final int numCompletions;

  @override
  List<Object?> get props =>
      [wanderlist, completedActivities, inTrip, numCompletions];

  @override
  Map<String, dynamic> toJson() {
    return {
      'in_trip': inTrip as bool,
      'num_completions': numCompletions as num,
      'wanderlist': wanderlist.toRef(),
      'completed_activities': completedActivities.map((activity)
        => activity.toRef()).toList(),
    };
  }


  UserWanderlist copyWith({
    Wanderlist? wanderlist,
    List<ActivityDetails>? activities,
    bool? inTrip,
    int? numCompletions,
    String ? id,
  }) {
    return UserWanderlist(
        wanderlist ?? this.wanderlist,
        activities ?? this.completedActivities,
        inTrip ?? this.inTrip,
        numCompletions ?? this.numCompletions,
        id ?? this.id,
    );
  }
}
