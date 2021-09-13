import 'dart:developer';

import 'package:application/models/activity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Wanderlist extends Equatable {
  Wanderlist(this.name, this.creatorName, this.activities);

  factory Wanderlist.fromJson(Map<String, dynamic> json) {
    List<ActivityDetails>? activities = List<ActivityDetails>.from(
        json['activities']
            .map((activity) => ActivityDetails.fromJson(activity))
            .toList());
    return Wanderlist(
      json['name'],
      json['author_name'],
      activities ?? [],
    );
  }

  final String name;
  final String creatorName;
  final List<ActivityDetails> activities;

  @override
  List<Object?> get props => [name, creatorName, activities];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'author_name': creatorName,
      'activities': activities.map((activity) => activity.toJson()),
    };
  }

  Wanderlist copyWith({
    String? name,
    String? creatorName,
    List<ActivityDetails>? activities,
  }) {
    return Wanderlist(
      name ?? this.name,
      creatorName ?? this.creatorName,
      activities ?? this.activities,
    );
  }
}
