import 'dart:developer';

import 'package:application/models/activity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Wanderlist extends Equatable {
  Wanderlist(this.id, this.name, this.creatorName, this.activities, this.icon);

  factory Wanderlist.fromJson(Map<String, dynamic> json) {
    List<ActivityDetails>? activities = List<ActivityDetails>.from(
        json['activities'].map((activity) {
              return ActivityDetails.fromJson(activity);}
        ).toList());
    return Wanderlist(
      json['id'],
      json['name'],
      json['author_name'],
      activities,
      json['icon'],
    );
  }

  final String id;
  final String name;
  final String creatorName;
  final List<ActivityDetails> activities;
  final String icon;

  @override
  List<Object?> get props => [id, name, creatorName, activities, icon];

  Map<String, dynamic> toRef() {
    return {
      'ref': "wanderlists/" + id,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'author_name': creatorName,
      'activities': activities.map((activity) => activity.toRef()).toList(),
      'icon': icon,
    };
  }

  Wanderlist copyWith({
    String? id,
    String? name,
    String? creatorName,
    List<ActivityDetails>? activities,
    String? icon,
  }) {
    return Wanderlist(
      id ?? this.id,
      name ?? this.name,
      creatorName ?? this.creatorName,
      activities ?? this.activities,
      icon ?? this.icon,
    );
  }
}
