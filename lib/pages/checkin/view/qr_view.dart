import 'dart:developer';
import 'dart:io';

import 'package:application/components/apptheme.dart';
import 'package:application/components/activity_summary_item_large.dart';
import 'package:application/models/activity.dart';
import 'package:application/pages/checkin/widgets/new_reward_dialog.dart';
import 'package:application/pages/checkin/widgets/points_earned_dialog.dart';
import 'package:application/repositories/user/rest_user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../cubit/qr_cubit.dart';
import '../cubit/qr_state.dart';

const ANIMATION_DURATION = Duration(milliseconds: 500);

class _QRViewExampleState extends State<_QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return _buildQrView(context);
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 400.0
        : 400.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.pink,
        borderRadius: 10,
        borderLength: 40,
        borderWidth: 10,
        cutOutSize: 250,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;

        if (scanData != null) {
          String s = scanData.code;
          context.read<QrCubit>().gotCode(s);
        }
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class _QRViewExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QRViewExampleState();
  }
}

class _QRCameraView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<QrCubit, QrScannerState>(
      listener: (context, state) {},
      child: _QRViewExample(),
    );
  }
}

class _InfoOverlay extends StatelessWidget {
  final String text;

  _InfoOverlay(this.text);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(child: Container(), flex: 5),
      ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          padding: EdgeInsets.all(10),
          color: WanTheme.colors.white,
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "inter",
                fontSize: 18,
                fontWeight: FontWeight.w200,
              ),
            ),
          ),
        ),
      ),
      Expanded(child: Container(), flex: 1),
    ]);
  }
}

class _QrAddActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QrCubit, QrScannerState>(builder: (context, state) {
      return _buildWidget(context, state);
    }, listener: (context, state) {
      if (state is AddedActivity) {
        //context.read<QrCubit>().checkForReward();
      } else if (state is NewReward) {
        log("show dialog");
        showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(WanTheme.CARD_CORNER_RADIUS),
            ),
            child: NewRewardDialog(
              state.newReward,
              () => Navigator.of(context).pop(),
            ),
          ),
        );
      }
    });
  }

  _buildWidget(BuildContext context, QrScannerState state) {
    if (state is QrScannerError) {
      return Stack(
        children: <Widget>[_QRCameraView(), _InfoOverlay(state.errorMsg)],
      );
    } else if (state is QrScannerLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (state is GotActivity) {
      return _buildCheckinContent(
        context,
        "Checking you in...",
        state.activity,
        AddedPointsCard(
          loading: true,
        ),
        hasContinueButton: false,
      );
    } else if (state is AddedActivity) {
      return _buildCheckinContent(
        context,
        "We've checked you in!",
        state.activity,
        AddedPointsCard(
          loading: false,
          success: true,
          beforePoints: state.beforePoints,
          afterPoints: state.afterPoints,
          activityPoints: state.activityPoints,
        ),
      );
    } else if (state is NewReward) {
      return _buildCheckinContent(
        context,
        "We've checked you in!",
        state.activity,
        AddedPointsCard(
          loading: false,
          success: true,
          beforePoints: state.beforePoints,
          afterPoints: state.afterPoints,
          activityPoints: state.activityPoints,
        ),
      );
    } else if (state is ActivityAlreadyComplete) {
      return _buildCheckinContent(
        context,
        "You've already checked into this activity before",
        state.activity,
        AddedPointsCard(
          loading: false,
          success: false,
        ),
      );
    }

    throw Exception("oops, fell through");
  }

  Widget _buildCheckinContent(BuildContext context, String headerText,
      ActivityDetails activity, AddedPointsCard card,
      {bool hasContinueButton = true}) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        bottom: 25,
      ),
      child: Column(
        children: <Widget>[
          Text(
            headerText,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 24,
              fontFamily: "inter",
              fontWeight: FontWeight.w500,
              color: WanTheme.colors.pink,
            ),
          ),
          Spacer(),
          ActivitySummaryItemLarge(activity),
          Spacer(),
          card,
          Spacer(),
          Visibility(
            visible: hasContinueButton,
            maintainSize: true,
            maintainState: true,
            maintainAnimation: true,
            child: ElevatedButton(
              onPressed: () => context.read<QrCubit>().returnToQrScanner(),
              child: Text("Continue"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    WanTheme.BUTTON_CORNER_RADIUS,
                  ),
                ),
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}

class WanQrScanner extends StatelessWidget {
  WanQrScanner();

  @override
  Widget build(BuildContext context) {
    return BlocListener<QrCubit, QrScannerState>(
      listener: (context, state) {},
      child: _QrAddActivity(),
    );
  }
}

class WanQrPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<QrCubit>(
      create: (BuildContext context) => QrCubit(RestUserRepository()),
      child: WanQrScanner(),
    );
  }
}
