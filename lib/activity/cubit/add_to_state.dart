import 'package:application/components/list_of_wanderlists.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:application/models/wanderlist.dart';
import 'package:flutter/material.dart';

abstract class ActivityAddState {}

class ActivityAddInitial implements ActivityAddState {}

class ActivityAddLoading implements ActivityAddState {}

class ActivityAddLoaded implements ActivityAddState {
  const ActivityAddLoaded(this.wanderlists);
  final List<UserWanderlist> wanderlists;
}
