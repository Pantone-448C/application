import 'package:application/models/activity.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:application/models/wanderlist.dart';
import 'package:application/repositories/user/i_user_repository.dart';
import 'package:application/repositories/wanderlist/i_wanderlist_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_to_state.dart';

class ActivityAddCubit extends Cubit<ActivityAddState> {
  ActivityAddCubit(
    this.userRepository,
    this.wanderlistRepository,
    this.activityDetails,
  ) : super(ActivityAddInitial()) {
    emit(ActivityAddInitial());
    loadActivityAdd();
  }

  final IUserRepository userRepository;
  final IWanderlistRepository wanderlistRepository;
  final ActivityDetails activityDetails;

  Future<void> loadActivityAdd() async {
    var wanderlists = await userRepository.getUserWanderlists();
    emit(ActivityAddLoaded(
        List.of(wanderlists.map((UserWanderlist w) => w.wanderlist))));
  }

  Future<void> addActivityToWanderlist(Wanderlist wanderlist) async {
    wanderlist.activities.add(activityDetails);
    wanderlistRepository.setWanderlist(wanderlist);
  }
}
