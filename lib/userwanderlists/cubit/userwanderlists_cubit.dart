import 'dart:developer';

import 'package:application/models/user.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:application/models/wanderlist.dart';
import 'package:application/repositories/user/i_user_repository.dart';
import 'package:application/repositories/wanderlist/i_wanderlist_repository.dart';
import 'package:application/userwanderlists/cubit/userwanderlists_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserWanderlistsCubit extends Cubit<UserWanderlistsState> {
  final IUserRepository userRepository;
  final IWanderlistRepository wanderlistRepository;

  UserWanderlistsCubit(this.userRepository, this.wanderlistRepository)
      : super(UserWanderlistsInitial()) {
    var l = userRepository.getUserWanderlists();
    _loadLists();
  }

  Future<void> _loadLists() async {
    List<UserWanderlist> w =
        (await userRepository.getUserWanderlists()).toList();
    emit(UserWanderlistsLoaded(w));
  }

  void swap(int old, int n) {
    if (state is UserWanderlistsLoaded) {
      var c = state as UserWanderlistsLoaded;

      int len = c.wanderlists.length;
      var l = List<UserWanderlist>.from(c.wanderlists);

      print('$old to $n whlen: $len\n\n');
      if (old < n) {
        n -= 1;
      }

      final UserWanderlist elem = l.removeAt(old);
      l.insert(n, elem);

      len = l.length;
      print('$old to $n whyyy len: $len\n\n');

      emit(UserWanderlistsLoaded(l));
    }
    emit(state);
  }

  addEmptyUserWanderlist(String name) async {
    emit(UserWanderlistsCreating());
    UserDetails details = await userRepository.getUserData();
    String creatorName = details.firstName + " " + details.lastName;
    Wanderlist wanderlist = Wanderlist("", name, creatorName, [], "");
    DocumentReference ref =
        await wanderlistRepository.addWanderlist(wanderlist);
    wanderlist = wanderlist.copyWith(id: ref.id);
    UserWanderlist userWanderlist =
        UserWanderlist(wanderlist, [], false, 0, ref.id);
    await userRepository.addUserWanderlist(userWanderlist);
    await _loadLists();
  }

//  reorder()

// delete()
// add()

}
