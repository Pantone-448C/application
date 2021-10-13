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
    this.status,
  );

  final String name;
  final String iconURL;
  final String caption;
  final String offer;
  final String location;
  final Function() onRedeemPress;
  final RewardDetailsPopupStatus status;

  static final double CORNER_RADIUS = WanTheme.CARD_CORNER_RADIUS;

  @override
  State<RewardDetailsPopup> createState() => _RewardDetailsPopupState();
}

class _RewardDetailsPopupState extends State<RewardDetailsPopup> {
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
            child: Icon(Icons.close, size: 24, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context) {
    return Column(
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
            style: Theme.of(context).textTheme.headline3),
      ],
    );
  }

  Widget _buildOfferPill(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 50, maxWidth: 170),
      decoration: BoxDecoration(
        color: WanTheme.colors.bgOrange,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Center(
        child: Text(
          this.widget.offer,
          style: Theme.of(context).textTheme.headline3!.copyWith(
                fontWeight: FontWeight.w600,
                color: WanTheme.colors.orange,
              ),
        ),
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
          padding: EdgeInsets.only(top: 25.0),
          alignment: Alignment.bottomCenter,
          constraints: BoxConstraints(
            maxWidth: 300,
            maxHeight: 120,
          ),
          decoration: BoxDecoration(),
          child: _buildRedemptionButton(context),
        ),
      ),
    );
  }

  Widget _buildRedemptionButton(BuildContext context) {
    return Column(
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: 190,
            maxHeight: 60,
          ),
          width: 190,
          height: 60,
          child: ElevatedButton(
            onPressed: () {},
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
}
