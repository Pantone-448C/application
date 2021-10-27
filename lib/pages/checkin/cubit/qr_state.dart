import 'package:application/models/activity.dart';
import 'package:application/models/reward.dart';
import 'package:application/models/user.dart';

class QrScannerState {
  const QrScannerState();
}

class QrScannerInitial extends QrScannerState {
  const QrScannerInitial();
}

class QrScannerLoading extends QrScannerState {
  const QrScannerLoading();
}

class QrScannerError extends QrScannerState {
  final String errorMsg;

  QrScannerError(this.errorMsg);
}

class AddActivity extends QrScannerState {
  final String activity;

  AddActivity(this.activity);
}

class GotActivity extends QrScannerState {
  final ActivityDetails activity;

  GotActivity(this.activity);
}

class ActivityAlreadyComplete extends QrScannerState {
  final ActivityDetails activity;

  ActivityAlreadyComplete(this.activity);
}

class AddedActivity extends QrScannerState {
  final ActivityDetails activity;
  final UserDetails user;
  final int beforePoints;
  final int afterPoints;
  final int activityPoints;

  AddedActivity(this.activity, this.user, this.beforePoints, this.afterPoints,
      this.activityPoints);
}

class NewReward extends QrScannerState {
  final ActivityDetails activity;
  final UserDetails user;
  final int beforePoints;
  final int afterPoints;
  final int activityPoints;
  final Reward newReward;

  NewReward(this.activity, this.user, this.beforePoints, this.afterPoints,
      this.activityPoints, this.newReward);
}
