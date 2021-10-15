import 'package:application/activity/cubit/activity_cubit.dart';
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

  Future<void> flipPin(UserWanderlist userWanderlist) async {
    userWanderlist.inTrip = !userWanderlist.inTrip;
    print(userWanderlist.inTrip);

    List<UserWanderlist> newList = (state as UserWanderlistsLoaded).wanderlists;
    emit(UserWanderlistsLoaded(newList));
    userRepository
        .updateUserWanderlists((state as UserWanderlistsLoaded).wanderlists);
  }

  Future<void> swap(int oldIndex, int newIndex) async {
    if (state is UserWanderlistsLoaded) {
      var c = state as UserWanderlistsLoaded;

      var l = List<UserWanderlist>.from(c.wanderlists);

      if (oldIndex < newIndex) {
        newIndex -= 1;
      }

      final UserWanderlist elem = l.removeAt(oldIndex);
      l.insert(newIndex, elem);

      userRepository.updateUserWanderlists(l);

      emit(UserWanderlistsLoaded(l));
    }
    emit(state);
  }

  addEmptyUserWanderlist(String name) async {
    emit(UserWanderlistsCreating());
    UserDetails details = await userRepository.getUserData();
    String creatorName = details.firstName + " " + details.lastName;
    Wanderlist wanderlist = Wanderlist("", name, creatorName, [], "");
    wanderlist = await wanderlistRepository.addWanderlist(wanderlist);
    UserWanderlist userWanderlist = UserWanderlist(wanderlist, [], false, 0, wanderlist.id);
    await userRepository.addUserWanderlist(userWanderlist);
    await _loadLists();
  }

//  reorder()

// delete()
// add()

}
