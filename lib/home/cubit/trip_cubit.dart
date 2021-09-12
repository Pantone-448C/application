import 'package:application/models/activity.dart';
import 'package:application/models/user.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:application/models/wanderlist.dart';
import 'package:application/repositories/activity/i_activity_repository.dart';
import 'package:application/repositories/user/i_user_repository.dart';
import 'package:application/repositories/wanderlist/i_wanderlist_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'trip_state.dart';

class TripCubit extends Cubit<TripState> {
  TripCubit(this.userRepository) : super(TripInitial()) {
    emit(TripInitial());
    getTripInfo();
  }

  final IUserRepository userRepository;

  Future<void> getTripInfo() async {
    emit(TripLoading());
    UserDetails user = await userRepository.getUserData();
    List<UserWanderlist> wanderlists =
        (await userRepository.getActiveWanderlists()).toList();

    int numWanderlists = wanderlists.length;
    int percentageComplete = calculatePercentageComplete(wanderlists);
    int totalPoints = calculateTotalPoints(wanderlists);

    emit(TripLoaded("Brisbane", numWanderlists, percentageComplete, totalPoints,
        wanderlists.toList(), user.firstName));
  }

  int calculatePercentageComplete(List<UserWanderlist> wanderlists) {
    return 0;
  }

  int calculateTotalPoints(List<UserWanderlist> wanderlists) {
    return 0;
  }
}
