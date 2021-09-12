import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:application/models/userwanderlists.dart';
import 'package:equatable/equatable.dart';

import 'userwanderlists_cubit.dart';

abstract class UserWanderlistsState {
  const UserWanderlistsState();
}

class UserWanderlistsInitial implements UserWanderlistsState {
  const UserWanderlistsInitial();
}

class UserWanderlistsSearching implements UserWanderlistsState {
  const UserWanderlistsSearching ();
}


class UserWanderlistsSearchResults implements UserWanderlistsState {
  final List<UserWanderlist> wanderlists;

  const UserWanderlistsSearchResults(this.wanderlists);

  @override
  List<Object?> get props => [wanderlists];

  UserWanderlistsSearchResults copyWith ({List<UserWanderlist> ? wanderlists}) {
    return UserWanderlistsSearchResults(wanderlists ?? this.wanderlists);
  }

}

class UserWanderlistsLoaded extends Equatable implements UserWanderlistsState {
  final List<UserWanderlist> wanderlists;

  const UserWanderlistsLoaded(this.wanderlists);

  @override
  List<Object?> get props => [wanderlists];

  UserWanderlistsLoaded copyWith ({List<UserWanderlist> ? wanderlists}) {
    return UserWanderlistsLoaded(wanderlists ?? this.wanderlists);
  }


}