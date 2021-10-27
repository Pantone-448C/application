import 'package:application/models/user_wanderlist.dart';

abstract class ActivityAddState {}

class ActivityAddInitial implements ActivityAddState {}

class ActivityAddLoading implements ActivityAddState {}

class ActivityAddLoaded implements ActivityAddState {
  const ActivityAddLoaded(this.wanderlists);

  final List<UserWanderlist> wanderlists;
}
