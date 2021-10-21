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
    int pointsForNextReward = await userRepository.getPointsForNextReward();
    int points = calculateTotalPoints(user.completedActivities);

    emit(UserLoaded(points, pointsForNextReward - points, pointsForNextReward,
        points / pointsForNextReward, userWanderlists));
  }

  int calculateTotalPoints(List<ActivityDetails> userActivities) {
    int totalPoints = 0;
    for (ActivityDetails details in userActivities) {
      totalPoints += details.points;
    }

    while (totalPoints >= 0) {
      totalPoints -= 1000;
    }

    totalPoints += 1000;

    return totalPoints;
  }
}
