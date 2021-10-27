import 'package:application/models/activity.dart';
import 'package:application/models/reward.dart';
import 'package:application/models/user.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:application/repositories/activity/i_activity_repository.dart';
import 'package:application/repositories/user/i_user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(this.userRepository, this.activityRepository)
      : super(UserInitial()) {
    emit(UserInitial());
    getTripInfo();
  }

  final IUserRepository userRepository;
  final IActivityRepository activityRepository;

  Future<void> getTripInfo() async {
    emit(UserLoading());

    var pointsForNextReward = userRepository.getPointsForNextReward();
    var recs = activityRepository.getActivities();

    UserDetails user = await userRepository.getUserData();
    var numRewards = 0;
    if (user.originalJSON["rewards"] != null) {
      numRewards = (user.originalJSON["rewards"] as List)
          .map((reward) => Reward.fromJson(reward as Map<String, dynamic>))
          .length;
    }

    List<UserWanderlist> userWanderlists =
      user.wanderlists.where((wanderlist) => wanderlist.inTrip).toList();

    int points = calculateTotalPoints(user.completedActivities);

    emit(UserLoaded(points, (await pointsForNextReward) - points, await pointsForNextReward,
        points / (await pointsForNextReward), userWanderlists, numRewards,
        await recs));
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
