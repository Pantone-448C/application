import 'package:application/models/userwanderlists.dart';
import 'package:application/userwanderlists/cubit/userwanderlists_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class UserWanderlistsCubit extends Cubit<UserWanderlistsState> {
  late List<UserWanderlist> wanderlists;

  UserWanderlistsCubit(wanderlists) : super(UserWanderlistsLoaded(wanderlists)) {
    this.wanderlists = List.empty();

  }

  void swap(int old, int n) {
    if (state is UserWanderlistsLoaded) {
      var c = state as UserWanderlistsLoaded;

      int len = c.wanderlists.length;

      print('$old to $n whlen: $len\n\n');
      if (old < n) {
        n -= 1;
      }

      final UserWanderlist elem = c.wanderlists.removeAt(old);
      c.wanderlists.insert(n, elem);

      len = c.wanderlists.length;
      print('$old to $n whyyy len: $len\n\n');

      emit(UserWanderlistsLoaded(c.wanderlists));
    }
    emit(state);
  }


    void filter_search(String query) {

    List<UserWanderlist> matches = List.empty();
    List<String> words = query.split(" ");
    Set<int> added = Set<int> ();
    for (var word in words) {
      for (var list in wanderlists) {
        if (!added.contains(list.wanderlist.id)) {
          if (list.wanderlist.name.contains(word)
           || list.wanderlist.creatorName.contains(word)) {
            added.add(list.wanderlist.id);
            matches.add(list);
          }
        }
      }
    }

    emit(UserWanderlistsSearchResults(matches));

  }

  void load() {
    final List<UserWanderlist> l = [
      UserWanderlist(
          userId: 0,
          numCompleted: 0,
          numTotal: 1,
          wanderlist: UserWanderlistItem (
            id: 0,
            name: "Cool Item",
            image: 'https://topost.net/deco/media/img0.png',
            creatorName: 'David Smith',
          )
      )
    ];

    emit(UserWanderlistsLoaded(l));

  }


//  reorder()

// delete()

// add()

}
