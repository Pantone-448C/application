import 'package:application/models/activity.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:application/models/wanderlist.dart';
import 'package:application/repositories/wanderlist/i_wanderlist_repository.dart';
import 'package:application/wanderlist/cubit/wanderlist_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WanderlistCubit extends Cubit<WanderlistState> {
  WanderlistCubit(this.wanderlistRepository) : super(Initial());

  IWanderlistRepository wanderlistRepository;

  loadWanderlists(UserWanderlist wanderlist) async {
    if (state is Initial) {
      emit(Loading());
      await Future.delayed(Duration(seconds: 0));
      emit(Viewing(wanderlist));
    } else {
      emit(state);
    }
  }

  UserWanderlist _deepCopyActivityList(UserWanderlist wanderlist) {
    List<ActivityDetails> copiedActivities = []
      ..addAll(wanderlist.wanderlist.activities);
    return wanderlist.copyWith(
      wanderlist: wanderlist.wanderlist.copyWith(activities: copiedActivities),
    );
  }

  startEdit(UserWanderlist wanderlist) {
    if (state is Viewing) {
      emit(Editing(wanderlist, _deepCopyActivityList(wanderlist)));
    } else {
      emit(state);
    }
  }

  endEdit() {
    if (state is Editing) {
      UserWanderlist userWanderlist = (state as Editing).wanderlist;
      emit(Saving());
      _save(userWanderlist.wanderlist);
      emit(Viewing(userWanderlist));
    } else {
      emit(state);
    }
  }

  cancelEdit() {
    if (state is Editing) {
      emit(Viewing((state as Editing).original));
    } else {
      emit(state);
    }
  }

  madeEdit(UserWanderlist wanderlist) {
    if (state is Editing) {
      emit(Editing(wanderlist, (state as Editing).original));
    } else {
      emit(state);
    }
  }

  addActivity(UserWanderlist wanderlist, ActivityDetails activity) {
    if (state is Editing) {
      (state as Editing).wanderlist.wanderlist.activities.add(activity);
      final original = (state as Editing).original;
      emit(Editing(wanderlist, original));
    } else {
      emit(state);
    }
  }

  Future<void> _save(Wanderlist wanderlist) async {
    await wanderlistRepository.setWanderlist(wanderlist);
  }

  Future<Wanderlist> _retrieve(String docReference) async {
    return wanderlistRepository.getWanderlist(docReference);
  }
}
