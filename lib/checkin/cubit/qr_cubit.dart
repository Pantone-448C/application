import 'dart:convert';
import 'dart:developer';

import 'package:application/models/activity.dart';
import 'package:application/models/reward.dart';
import 'package:application/models/user.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:application/repositories/activity/i_activity_repository.dart';
import 'package:application/repositories/user/i_user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'qr_state.dart';

const String ACTIVITY_NOT_EXIST = "Activity does not exist";
const String ACTIVITY_NOT_IN_LIST = "Activity is not in a list";

class QrCubit extends Cubit<QrScannerState> {
  IUserRepository userRepository;
  QrCubit(this.userRepository)
      : super(QrScannerError("Please Scan an Activity Code"));

  void gotCode(String c) {
    emit(QrScannerLoading());
    var code = jsonDecode(c);
    addActivity(code["activity"]);
  }

  Future<void> addActivity(String activity) async {
    ActivityDetails a;
    try {
      a = (await userRepository.getActivity(activity));
    } catch (e) {
      print(e);
      emit(QrScannerError("Invalid Activity Code."));
      return;
    }

    emit(GotActivity(a));

    List<UserWanderlist> lists =
        List<UserWanderlist>.from(await userRepository.getUserWanderlists());

    bool changed = false;
    lists.forEach((e) {
      if (e.wanderlist.activities.any((elem) {
        return elem.id == activity;
      })) {
        if (!e.completedActivities.contains(a)) {
          e.completedActivities.add(a);
          changed = true;
        }
        var list = e.wanderlist.id;
      }
    });

    UserDetails user = await userRepository.getUserData();
    int beforePoints = calculateTotalPoints(user.completedActivities);

    /* Add activity to user's completed activity, for points tracking */
    var completed =
        (await userRepository.getUserCompletedActivities()).toList();
    completed.add(a);
    changed = true; // TODO: Add condition on frequency of earning points

    if (!changed) {
      emit(ActivityAlreadyComplete(a));
    }

    // Find out how many points the user had before completing the activity
    // and how many they have now that they have completed the activity.
    int afterPoints = beforePoints;
    if (changed) {
      afterPoints = beforePoints + a.points;
    }

    await userRepository.updateUserWanderlists(lists);
    await userRepository.updateUserCompletedActivities(completed);

    emit(AddedActivity(a, user, beforePoints, afterPoints, a.points));
  }

  Future<void> checkForReward() async {
    if (state is AddedActivity) {
      AddedActivity castState = state as AddedActivity;
      int userRewardPoints = await userRepository.getPointsForNextReward();
      if (true || castState.afterPoints >= userRewardPoints) {
        log("hi");
        Reward reward = await userRepository.getRecommendedReward();
        emit(NewReward(
          castState.activity,
          castState.user,
          castState.beforePoints,
          castState.afterPoints,
          castState.activityPoints,
          reward,
        ));
      }
    }
  }

  void returnToQrScanner() {
    emit(QrScannerError("Please Scan an Activity Code"));
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
