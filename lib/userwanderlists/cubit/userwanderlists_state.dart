import 'package:application/models/user_wanderlist.dart';
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

class UserWanderlistsSearch extends UserWanderlistsLoaded implements UserWanderlistsState {
  final List<UserWanderlist> original_wanderlists;

  const UserWanderlistsSearch(this.original_wanderlists, List<UserWanderlist> orig) : super(orig);

  @override
  List<Object?> get props => [original_wanderlists, wanderlists];

  UserWanderlistsSearch copyWith ({List<UserWanderlist> ? wanderlists,List<UserWanderlist> ? original_wanderlists}) {
    return UserWanderlistsSearch(wanderlists ?? this.wanderlists,
        original_wanderlists ?? this.original_wanderlists
    );
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

