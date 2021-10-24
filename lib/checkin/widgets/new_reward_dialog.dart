import 'package:application/apptheme.dart';
import 'package:application/components/rewards/reward_card.dart';
import 'package:application/models/reward.dart';
import 'package:flutter/material.dart';

class NewRewardDialog extends StatelessWidget {
  NewRewardDialog(this.reward, this.onContinuePress, {this.onClosePress});

  final Reward reward;
  final Function() onContinuePress;
  final Function()? onClosePress;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 380,
        maxHeight: 340,
        minHeight: 340,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(WanTheme.CARD_CORNER_RADIUS),
        color: Colors.white,
      ),
      child: _DialogContent(reward, onContinuePress, onClosePress),
    );
  }
}

class _DialogContent extends StatelessWidget {
  _DialogContent(this.reward, this.onContinuePress, this.onClosePress);

  final Reward reward;
  final Function() onContinuePress;
  final Function()? onClosePress;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text("Congratulations!"),
            onClosePress != null
                ? IconButton(icon: Icon(Icons.close), onPressed: onClosePress)
                : Container(),
          ],
        ),
        _NewReward(reward),
        _ActionButtons(onContinuePress),
      ],
    );
  }
}

class _NewReward extends StatelessWidget {
  _NewReward(this.reward);

  final Reward reward;

  @override
  Widget build(BuildContext context) {
    bool redeemed = reward.redemptionDate == null;

    return Column(
      children: [
        Text("You've received a reward!"),
        RewardCard(
          reward.name,
          reward.imageUrl,
          reward.value,
          reward.location,
          redeemed,
          () {},
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  _ActionButtons(this.onContinuePress);

  final Function() onContinuePress;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onContinuePress,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(WanTheme.BUTTON_CORNER_RADIUS),
            ),
          ),
        ),
      ),
      child: Text("Continue"),
    );
  }
}
