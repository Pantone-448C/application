import 'package:application/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

enum RewardDetailsPopupStatus {
  Unredeemed,
  Redeeming,
  Success,
}

class RewardDetailsPopup extends StatefulWidget {
  RewardDetailsPopup(
    this.name,
    this.iconURL,
    this.caption,
    this.offer,
    this.location,
    this.onRedeemPress,
    this.onClosePress,
    this.status,
  );

  final String name;
  final String iconURL;
  final String caption;
  final String offer;
  final String location;

  /// onRedeemPress is an async function that completes an action when the
  /// "Redeem" button is pressed when the popup has an Unredeemed status.
  /// This should be used to update the database with details of this reward.
  final Future<String> Function() onRedeemPress;
  final Function() onClosePress;
  final RewardDetailsPopupStatus status;

  static final double CORNER_RADIUS = WanTheme.CARD_CORNER_RADIUS;

  @override
  State<RewardDetailsPopup> createState() => _RewardDetailsPopupState(status);
}

class _RewardDetailsPopupState extends State<RewardDetailsPopup> {
  _RewardDetailsPopupState(this.status);

  RewardDetailsPopupStatus status;
  String _redeemedDate = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 345, maxHeight: 385),
      decoration: BoxDecoration(
        color: WanTheme.colors.white,
        borderRadius: BorderRadius.circular(RewardDetailsPopup.CORNER_RADIUS),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          Spacer(),
          _buildDetailsSection(context),
          Spacer(),
          _buildRedemptionSection(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final Radius corner = Radius.circular(RewardDetailsPopup.CORNER_RADIUS);

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          constraints: BoxConstraints(maxHeight: 80, maxWidth: 345),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: corner, topRight: corner),
            image: DecorationImage(
              fit: BoxFit.fitWidth,
              image: NetworkImage(
                this.widget.iconURL,
              ),
            ),
          ),
        ),
        Container(
          constraints: BoxConstraints(maxHeight: 80, maxWidth: 345),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: corner, topRight: corner),
            gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.2),
                Colors.black.withOpacity(0.6),
              ],
              stops: [0.0, 1.0],
            ),
          ),
        ),
        _buildHeaderContent(context),
      ],
    );
  }

  Widget _buildHeaderContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Stack(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  this.widget.name,
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                ),
                Text(
                  this.widget.caption,
                  style: TextStyle(
                    fontFamily: "inter",
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            child: IconButton(
              padding: EdgeInsets.all(0),
              constraints: BoxConstraints(),
              focusColor: Colors.black,
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: this.widget.onClosePress,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Column(
        children: [
          _buildOfferPill(context),
          Text(
            "at",
            style: Theme.of(context).textTheme.headline3!.copyWith(
                  color: WanTheme.colors.grey,
                  fontWeight: FontWeight.w300,
                ),
          ),
          Text(this.widget.location,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline3),
        ],
      ),
    );
  }

  Widget _buildOfferPill(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 50, minWidth: 170),
      decoration: BoxDecoration(
        color: WanTheme.colors.bgOrange,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Column(
        // This Column is a hacky way to center the text vertically, without
        // taking up the entire width of the column and causing the pill to be
        // too wide.
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            this.widget.offer,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline3!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: WanTheme.colors.orange,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildRedemptionSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        bottom: 20.0,
      ),
      child: DottedBorder(
        dashPattern: [15, 5],
        strokeWidth: 1.0,
        color: WanTheme.colors.pink,
        borderType: BorderType.RRect,
        radius: Radius.circular(RewardDetailsPopup.CORNER_RADIUS),
        child: Container(
          alignment: Alignment.center,
          constraints: BoxConstraints(
            maxWidth: 300,
            maxHeight: 120,
          ),
          decoration: BoxDecoration(),
          child: _buildRedemptionInnerBox(context),
        ),
      ),
    );
  }

  Widget _buildRedemptionInnerBox(BuildContext context) {
    if (this.status == RewardDetailsPopupStatus.Unredeemed) {
      return _buildRedemptionButton(context);
    } else if (this.status == RewardDetailsPopupStatus.Redeeming) {
      return _buildRedemptionLoading();
    } else if (this.status == RewardDetailsPopupStatus.Success) {
      return _buildRedemptionSuccess();
    } else {
      return Container();
    }
  }

  void _redeemPress() async {
    setState(() {
      status = RewardDetailsPopupStatus.Redeeming;
    });
    String redeemed = await this.widget.onRedeemPress();
    setState(() {
      status = RewardDetailsPopupStatus.Success;
      _redeemedDate = redeemed;
    });
  }

  Widget _buildRedemptionButton(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: 190,
            maxHeight: 60,
          ),
          width: 190,
          height: 60,
          child: ElevatedButton(
            onPressed: _redeemPress,
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(WanTheme.BUTTON_CORNER_RADIUS),
                  ),
                ),
              ),
            ),
            child: Text(
              "Redeem!",
              style: TextStyle(
                fontFamily: "inter",
                fontSize: 18,
              ),
            ),
          ),
        ),
        Text(
          "press button to redeem",
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                color: WanTheme.colors.grey,
              ),
        ),
      ],
    );
  }

  Widget _buildRedemptionLoading() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildRedemptionSuccess() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.done, size: 30, color: WanTheme.colors.pink),
          Text(
            "Successfully redeemed!",
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
          Text(
            this._redeemedDate,
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 12,
              fontWeight: FontWeight.w300,
              color: WanTheme.colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
