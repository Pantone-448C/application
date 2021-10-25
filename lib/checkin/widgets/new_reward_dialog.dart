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
      padding: EdgeInsets.all(16.0),
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
          mainAxisAlignment: onClosePress != null
              ? MainAxisAlignment.spaceAround
              : MainAxisAlignment.center,
          children: [
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (Rect bounds) =>
                  WanTheme.colors.pinkOrangeGradient.createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
              child: Text(
                "Congratulations!",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            onClosePress != null
                ? IconButton(icon: Icon(Icons.close), onPressed: onClosePress)
                : Container(),
          ],
        ),
        Spacer(),
        _NewReward(reward),
        Spacer(),
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
        Text(
          "You've received a new reward!",
          style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16),
        ),
        Padding(padding: EdgeInsets.only(top: 16.0)),
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
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            WanTheme.BUTTON_CORNER_RADIUS,
          ),
        ),
      ),
      child: Text("Continue"),
    );
  }
}
