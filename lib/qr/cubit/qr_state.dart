

import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScannerState {
  const QrScannerState();
}


class QrScannerFinished extends QrScannerState {
  const QrScannerFinished();
}

class AddActivity extends QrScannerState {
  final String activity;

  AddActivity(this.activity);
}