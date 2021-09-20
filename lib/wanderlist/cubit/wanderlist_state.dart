import 'package:application/models/activity.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:application/models/wanderlist.dart';
import 'package:equatable/equatable.dart';

abstract class WanderlistState extends Equatable {}

class Initial implements WanderlistState {
  @override
  List<Object?> get props => throw [];

  @override
  bool? get stringify => null;
}

class Loading implements WanderlistState {
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => null;
}

class Viewing implements WanderlistState {
  Viewing(this.wanderlist);

  final UserWanderlist wanderlist;

  @override
  List<Object?> get props => [wanderlist];

  @override
  bool? get stringify => null;
}

class Editing implements WanderlistState {
  Editing(this.wanderlist, this.original);

  final UserWanderlist wanderlist;
  final UserWanderlist original;

  @override
  List<Object?> get props => [wanderlist, original];

  @override
  bool? get stringify => null;
}

class AddingActivity implements WanderlistState {
  AddingActivity({this.newActivity});

  final ActivityDetails? newActivity;

  @override
  List<Object?> get props => [newActivity];

  @override
  bool? get stringify => null;
}

class Saving implements WanderlistState {
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => null;
}

class Saved implements WanderlistState {
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => null;
}
