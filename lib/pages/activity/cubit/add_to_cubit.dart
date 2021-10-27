import 'package:application/models/user.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:application/models/wanderlist.dart';
import 'package:application/repositories/activity/i_activity_repository.dart';
import 'package:application/repositories/user/i_user_repository.dart';
import 'package:application/repositories/wanderlist/i_wanderlist_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_to_state.dart';

class ActivityAddCubit extends Cubit<ActivityAddState> {
  ActivityAddCubit(
    this.userRepository,
    this.wanderlistRepository,
    this.activityRepository,
    this.activityId,
  ) : super(ActivityAddInitial()) {
    emit(ActivityAddInitial());
    loadActivityAdd();
  }

  final IUserRepository userRepository;
  final IWanderlistRepository wanderlistRepository;
  final IActivityRepository activityRepository;
  final String activityId;

  Future<void> loadActivityAdd() async {
    var userWanderlists = (await userRepository.getUserWanderlists());
    emit(ActivityAddLoaded(List.of(userWanderlists)));
  }

  Future<void> createWanderlist(String name) async {
    emit(ActivityAddLoading());
    UserDetails details = await userRepository.getUserData();
    String creatorName = details.firstName + " " + details.lastName;
    Wanderlist wanderlist = Wanderlist("", name, creatorName, [], "");
    wanderlist = await wanderlistRepository.addWanderlist(wanderlist);
    UserWanderlist userWanderlist =
        UserWanderlist(wanderlist, [], false, 0, wanderlist.id);
    userRepository.addUserWanderlist(userWanderlist);
    addActivityToWanderlist(wanderlist);
  }

  Future<void> addActivityToWanderlist(Wanderlist wanderlist) async {
    wanderlist.activities.add(await activityRepository.getActivity(activityId));
    wanderlistRepository.setWanderlist(wanderlist);
  }
}
