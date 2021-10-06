import 'package:application/models/activity.dart';
import 'package:application/models/user.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:application/models/wanderlist.dart';
import 'package:application/repositories/activity/i_activity_repository.dart';
import 'package:application/repositories/user/i_user_repository.dart';
import 'package:application/repositories/wanderlist/i_wanderlist_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(this.userRepository) : super(UserInitial()) {
    emit(UserInitial());
    getTripInfo();
  }

  final IUserRepository userRepository;

  Future<void> getTripInfo() async {
    emit(UserLoading());
    UserDetails user = await userRepository.getUserData();
    List<UserWanderlist> userWanderlists =
        (await userRepository.getActiveWanderlists()).toList();
    List<Wanderlist> wanderlists = userWanderlists
        .map((userWanderlist) => userWanderlist.wanderlist)
        .toList();

    emit(UserLoaded(442, 1000 - 442, 1000, 442 / 1000, wanderlists));
  }

  int calculatePercentageComplete(List<UserWanderlist> wanderlists) {
    return 0;
  }

  int calculateTotalPoints(List<UserWanderlist> wanderlists) {
    return 0;
  }
}
