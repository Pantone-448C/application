import 'package:application/components/apptheme.dart';
import 'package:application/components/rewards/reward_card.dart';
import 'package:application/models/reward.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class NewRewardDialog extends StatefulWidget {
  NewRewardDialog(this.reward, this.onContinuePress, {this.onClosePress});

  final Reward reward;
  final Function() onContinuePress;
  final Function()? onClosePress;

  @override
  State<NewRewardDialog> createState() => _NewRewardDialogState();
}

class _NewRewardDialogState extends State<NewRewardDialog> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    _confettiController.play();
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
      child: Stack(
        children: [
          _DialogContent(
              widget.reward, widget.onContinuePress, widget.onClosePress),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              emissionFrequency: 0.1,
              colors: [
                Colors.green,
                Colors.blue,
                WanTheme.colors.pink,
                WanTheme.colors.orange,
                Colors.purple,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DialogContent extends StatefulWidget {
  _DialogContent(this.reward, this.onContinuePress, this.onClosePress);

  final Reward reward;
  final Function() onContinuePress;
  final Function()? onClosePress;

  @override
  State<_DialogContent> createState() => _DialogContentState();
}

class _DialogContentState extends State<_DialogContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: widget.onClosePress != null
              ? MainAxisAlignment.spaceAround
              : MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              color: WanTheme.colors.orange,
            ),
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
            widget.onClosePress != null
                ? IconButton(
                    icon: Icon(Icons.close), onPressed: widget.onClosePress)
                : Container(),
          ],
        ),
        Spacer(),
        _NewReward(widget.reward),
        Spacer(),
        _ActionButtons(widget.onContinuePress),
      ],
    );
  }
}

class _NewReward extends StatelessWidget {
  _NewReward(this.reward);

  final Reward reward;

  @override
  Widget build(BuildContext context) {
    bool redeemed = reward.redemptionDate != null;

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
