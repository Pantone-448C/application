import 'dart:developer';

import 'package:application/models/activity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Wanderlist extends Equatable {
  Wanderlist(
    this.id,
    this.name,
    this.creatorName,
    this.activityReferences,
    this.loadedActivities,
    this.icon,
  );

  factory Wanderlist.fromJson(Map<String, dynamic> json) {
    List<DocumentReference> activities = json['activities'];
    return Wanderlist(
      json['doc_ref'],
      json['name'],
      json['author_name'],
      activities,
      [],
      json['icon'],
    );
  }

  final String id;
  final String name;
  final String creatorName;
  final List<DocumentReference> activityReferences;
  final List<ActivityDetails> loadedActivities;
  final String icon;

  @override
  List<Object?> get props => [id, name, creatorName, activityReferences, icon];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'author_name': creatorName,
      'activities': loadedActivities.map((activity) => activity.toJson()),
      'icon': icon,
    };
  }

  Wanderlist copyWith({
    String? id,
    String? name,
    String? creatorName,
    List<DocumentReference>? activityReferences,
    List<ActivityDetails>? loadedActivities,
    String? icon,
  }) {
    return Wanderlist(
      id ?? this.id,
      name ?? this.name,
      creatorName ?? this.creatorName,
      activityReferences ?? this.activityReferences,
      loadedActivities ?? this.loadedActivities,
      icon ?? this.icon,
    );
  }
}
