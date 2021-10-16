import 'package:application/apptheme.dart';
import 'package:flutter/material.dart';

class UnusedRewardsDropdown extends StatelessWidget {
  UnusedRewardsDropdown(this.width, this.height, this.unusedRewards);

  final double width;
  final double height;
  final int unusedRewards;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.fromLTRB(
          width / 25, height / 7.5, width / 25, height / 7.5),
      decoration: BoxDecoration(
        color: WanTheme.colors.bgOrange,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(WanTheme.CARD_CORNER_RADIUS),
          bottomRight: Radius.circular(WanTheme.CARD_CORNER_RADIUS),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          unusedRewardsText(context, unusedRewards.toString()),
          Icon(Icons.expand_more, color: WanTheme.colors.orange),
        ],
      ),
    );
  }
}

RichText unusedRewardsText(BuildContext context, String unusedRewardsNum) {
  return RichText(
    text: TextSpan(
      style: Theme.of(context)
          .textTheme
          .headline4!
          .copyWith(color: WanTheme.colors.orange),
      children: [
        TextSpan(
          text: unusedRewardsNum,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        TextSpan(text: " unused rewards")
      ],
    ),
  );
}
