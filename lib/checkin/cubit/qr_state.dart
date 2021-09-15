

import 'package:application/models/activity.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

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

  AddedActivity(this.activity);
}
