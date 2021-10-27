
import 'package:application/models/activity.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class UserDetails extends Equatable {
  UserDetails(this.email, this.firstName, this.lastName, this.wanderlists,
      this.completedActivities,
      {this.originalJSON: const {}});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    List<UserWanderlist> wanderlists = [];

    if (json['wanderlists'] != null) {
      json['wanderlists'].forEach((wanderlist) {
        wanderlists.add(UserWanderlist.fromJson(wanderlist));
      });
    }

    List<ActivityDetails> completedActivities = [];
    if (json['completed_activities'] != null) {
      completedActivities = json['completed_activities']
          .map<ActivityDetails>(
              (activity) => ActivityDetails.fromJson(activity))
          .toList();
    }

    return UserDetails(
      json['email'],
      json['first_name'],
      json['last_name'],
      wanderlists,
      completedActivities,
      originalJSON: json,
    );
  }

  late Map<String, dynamic> originalJSON;
  final String email;
  final String firstName;
  final String lastName;
  List<UserWanderlist> wanderlists;
  List<ActivityDetails> completedActivities;

  @override
  List<Object?> get props => [email, firstName, lastName, wanderlists];

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> jsonWanderLists = List.empty(growable: true);

    wanderlists.forEach((element) {
      jsonWanderLists.add(element.toJson());
    });

    var jsonCompletedActivities = List.empty(growable: true);
    completedActivities.forEach((activity) {
      var activityReference =
          FirebaseFirestore.instance.collection("activities").doc(activity.id);
      jsonCompletedActivities.add(activityReference);
    });

    originalJSON['email'] = email;
    originalJSON['first_name'] = firstName;
    originalJSON['last_name'] = lastName;
    originalJSON['wanderlists'] = jsonWanderLists;
    originalJSON['completed_activities'] =
        completedActivities.map((a) => a.toRef()).toList();

    return originalJSON;
  }

  UserDetails copyWith({
    String? email,
    String? firstName,
    String? lastName,
    List<UserWanderlist>? wanderlists,
    List<ActivityDetails>? completedActivities,
  }) {
    return UserDetails(
      email ?? this.email,
      firstName ?? this.firstName,
      lastName ?? this.lastName,
      wanderlists ?? this.wanderlists,
      completedActivities ?? this.completedActivities,
    );
  }
}
