import 'dart:developer';

import 'package:application/models/activity.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class UserDetails extends Equatable {
  UserDetails(this.email, this.firstName, this.lastName, this.wanderlists,
      this.completedActivities);

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    List<UserWanderlist> wanderlists = [];
    if (json['wanderlists'] != null) {
      wanderlists = json['wanderlists']
          .map<UserWanderlist>(
              (wanderlist) => UserWanderlist.fromJson(wanderlist))
          .toList();
    }

    List<ActivityDetails> completedActivities = [];
    if (json['completed_activities'] != null) {
      completedActivities = json['completed_activities']
          .map<ActivityDetails>((completedActivities) =>
              ActivityDetails.fromJson(completedActivities))
          .toList();
    }

    return UserDetails(
      json['email'],
      json['first_name'],
      json['last_name'],
      wanderlists,
      completedActivities,
    );
  }

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

    return {
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'wanderlists': jsonWanderLists,
    };
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
