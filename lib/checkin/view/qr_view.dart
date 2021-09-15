import 'dart:io';

import 'package:application/apptheme.dart';
import 'package:application/components/activity_summary_item_large.dart';
import 'package:application/repositories/activity/activity_repository.dart';
import 'package:application/repositories/user/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../sizeconfig.dart';
import '../cubit/qr_cubit.dart';
import '../cubit/qr_state.dart';

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
    return
      _buildQrView(context);
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
          borderColor: Colors.red,
          overlayColor: Colors.transparent,
          borderRadius: 10,
          borderLength: 0,
          borderWidth: 0,
          cutOutSize: 400),
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
        Expanded(child: Container(), flex:5),
        ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child:Container(
                width: SizeConfig(context).wPc * 50,
                padding: EdgeInsets.all(10),
                color: WanTheme.colors.white,
                child: Center(child:
                Text(text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "inter",
                      fontSize: 18,
                      fontWeight: FontWeight.w200,
                    ))))),
        Expanded(child: Container(), flex: 1),
      ]);
  }

}


class _QrAddActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QrCubit, QrScannerState> (
      builder: (context, state) {
        if (state is QrScannerError) {
          return Stack(children: <Widget>[
            _QRCameraView(),
            _InfoOverlay(state.errorMsg)
          ]);
        } else if (state is QrScannerLoading ) {
          return Center(child: CircularProgressIndicator());
        } else if (state is GotActivity) {
          return  Column(children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 20, left:20, right:20, bottom:50),
              child: ActivitySummaryItemLarge(state.activity)),
            Center(child: CircularProgressIndicator()),
          ]);
        } else if (state is AddedActivity) {
          return  Column(children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 20, left:20, right:20, bottom:50),
                child: ActivitySummaryItemLarge(state.activity)),
            Center(child: Icon(Icons.check_circle_outline_rounded)),
          ]);
        } else if (state is ActivityAlreadyComplete) {
          return  Column(children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 20, left:20, right:20, bottom:50),
                child: ActivitySummaryItemLarge(state.activity)),
            Center(child: Text("Activity already added.")),
          ]);

        }

        throw Exception("oops, fell through");
        return Center(child: CircularProgressIndicator());
      }

    );
  }
}

class WanQrScanner extends StatelessWidget {

  WanQrScanner();

  @override
  Widget build(BuildContext context) {
    return BlocListener<QrCubit, QrScannerState> (
      listener: (context, state) {},
      child: _QrAddActivity(),
    );
  }

}

class WanQrPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<QrCubit> (
      create: (BuildContext context) => QrCubit(UserRepository()),
      child: WanQrScanner(),
    );
  }

}


