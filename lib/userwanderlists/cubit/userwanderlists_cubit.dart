import 'dart:developer';

import 'package:application/models/user.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:application/models/wanderlist.dart';
import 'package:application/repositories/user/i_user_repository.dart';
import 'package:application/repositories/wanderlist/i_wanderlist_repository.dart';
import 'package:application/userwanderlists/cubit/userwanderlists_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

      userRepository.updateUserWanderlists(l);

      emit(UserWanderlistsLoaded(l));
    }
    emit(state);
  }

  void finish_search() {
    if (state is UserWanderlistsSearch) {
      var c = state as UserWanderlistsSearch;
      List<UserWanderlist> original = List.of(c.original_wanderlists);
      emit(UserWanderlistsLoaded(original));
    }
  }

  void filter_search(String query) {
    List<UserWanderlist> original;
    if (state is UserWanderlistsSearch) {
      var c = state as UserWanderlistsSearch;
      original = List.of(c.original_wanderlists);
    } else {
      var c = state as UserWanderlistsLoaded;
      original = List.of(c.wanderlists);
    }

    if (query == "") {
      emit(UserWanderlistsLoaded(original));
      return;
    }

    List<UserWanderlist> matches = [];
    List<String> words = query.split(" ");
    Set<int> added = Set<int>();
    for (var word in words) {
      for (var list in original) {
        if (!added.contains(list.wanderlist.hashCode)) {
          if (list.wanderlist.name.contains(word) ||
              list.wanderlist.creatorName.contains(word)) {
            added.add(list.wanderlist.hashCode);
            matches.add(list);
          }
        }
      }
    }

    emit(UserWanderlistsSearch(original, matches));
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
