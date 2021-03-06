import 'package:application/models/user_wanderlist.dart';

abstract class UserWanderlistsState {
  const UserWanderlistsState();
}

class UserWanderlistsInitial implements UserWanderlistsState {
  const UserWanderlistsInitial();
}

class UserWanderlistsSearch extends UserWanderlistsLoaded
    implements UserWanderlistsState {
  final List<UserWanderlist> original_wanderlists;

  const UserWanderlistsSearch(
      this.original_wanderlists, List<UserWanderlist> orig)
      : super(orig);

  @override
  List<Object?> get props => [original_wanderlists, wanderlists];

  UserWanderlistsSearch copyWith(
      {List<UserWanderlist>? wanderlists,
      List<UserWanderlist>? original_wanderlists}) {
    return UserWanderlistsSearch(wanderlists ?? this.wanderlists,
        original_wanderlists ?? this.original_wanderlists);
  }
}

class UserWanderlistsLoaded implements UserWanderlistsState {
  final List<UserWanderlist> wanderlists;

  const UserWanderlistsLoaded(this.wanderlists);

  UserWanderlistsLoaded copyWith({List<UserWanderlist>? wanderlists}) {
    return UserWanderlistsLoaded(wanderlists ?? this.wanderlists);
  }
}

class UserWanderlistsCreating implements UserWanderlistsState {}
