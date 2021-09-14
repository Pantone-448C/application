import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'qr_state.dart';

class QrCubit extends Cubit<QrScannerState> {
  QrCubit() : super(QrScannerFinished());

  void gotCode(String c) {
    var code = jsonDecode(c);
    emit(AddActivity(code["activity"]));
  }

}



