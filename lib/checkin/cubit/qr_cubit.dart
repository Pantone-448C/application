import 'dart:convert';

import 'package:application/models/activity.dart';
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
      print("Trying to add activity: $activity");
      a = (await userRepository.getActivity(activity));
    } catch (e) {
      emit(QrScannerError("Invalid Activity Code."));
      return;
    }

    emit(GotActivity(a));

    UserDetails user = (await userRepository.getUserDataAndWanderlists());

    print("$activity exists");

    bool changed = false;
    List<UserWanderlist> lists = user.wanderlists;
    lists.forEach((e) {
      // TODO: if not in trip, add to trip
      if (e.wanderlist.activities.any((elem) {
          print("$elem.id $activity");
          return elem.id == activity;})) {
        if (!e.completedActivities.contains(a)) {
          e.completedActivities.add(a);
          changed = true;
        }
        var list = e.wanderlist.id;
        print("Added $activity to list $list");
      }
    });

    if (!changed) {
      emit(ActivityAlreadyComplete(a));
      return;
    }

    await userRepository.updateUserData(user);
    print("Sent new user json to complete activity: $user.toJson()");

    emit(AddedActivity(a));
  }

}




