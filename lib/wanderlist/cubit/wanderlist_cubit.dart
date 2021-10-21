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

  loadWanderlists(Wanderlist wanderlist) async {
    if (state is Initial) {
      emit(Loading());
      var newWl = await wanderlistRepository.getWanderlist(wanderlist.id);
      //emit(Editing(_deepCopyActivityList(wanderlist), _deepCopyActivityList(wanderlist)));
      // emit(Viewing(wanderlist));
      startEdit(newWl);
    } else {
      emit(state);
    }
  }

  Wanderlist _deepCopyActivityList(Wanderlist wanderlist) {
    List<ActivityDetails> copiedActivities = []..addAll(wanderlist.activities);
    return wanderlist.copyWith(activities: copiedActivities);
  }

  startEdit(Wanderlist wanderlist) {
    emit(Editing(wanderlist, _deepCopyActivityList(wanderlist)));
  }

  endEdit() {
    if (state is Editing) {
      Wanderlist wanderlist = (state as Editing).wanderlist;
      _save(wanderlist);
      emit(Viewing(wanderlist));
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

  madeEdit(Wanderlist wanderlist) {
    if (state is Editing) {
      emit(Editing(wanderlist, (state as Editing).original, isChanged: true));
    } else {
      emit(state);
    }
  }

  addActivity(Wanderlist wanderlist, ActivityDetails activity) {
    if (state is Editing) {
      (state as Editing).wanderlist.activities.add(activity);
      final original = (state as Editing).original;
      emit(Editing(wanderlist, original, isChanged: true));
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
