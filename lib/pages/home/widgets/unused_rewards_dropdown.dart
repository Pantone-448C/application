import 'package:application/components/apptheme.dart';
import 'package:application/pages/rewards/view/reward_list.dart';
import 'package:flutter/material.dart';

class UnusedRewardsDropdown extends StatelessWidget {
  UnusedRewardsDropdown(this.width, this.height, this.unusedRewards);

  final double width;
  final double height;
  final int unusedRewards;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: WanTheme.colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(WanTheme.CARD_CORNER_RADIUS),
          bottomRight: Radius.circular(WanTheme.CARD_CORNER_RADIUS),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: WanTheme.colors.orange,
          collapsedIconColor: WanTheme.colors.orange,
          title: unusedRewardsText(context, unusedRewards.toString()),
          children: [
            Container(
              constraints: BoxConstraints(maxHeight: 126),
              child: RewardsList(
                hasTitle: false,
                maxRewardNum: 1,
                carousel: true,
              ),
            )
          ],
        ),
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
        TextSpan(text: " rewards")
      ],
    ),
  );
}
