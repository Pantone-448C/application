import 'dart:developer';

import 'package:application/apptheme.dart';
import 'package:application/components/rewards/reward_card.dart';
import 'package:application/components/rewards/reward_details_popup.dart';
import 'package:application/models/reward.dart';
import 'package:application/repositories/user/rest_user_repository.dart';
import 'package:application/rewards/cubit/rewards_list_cubit.dart';
import 'package:application/rewards/cubit/rewards_list_state.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class RewardsList extends StatelessWidget {
  RewardsList({
    this.hasTitle = true,
    this.maxRewardNum = -1,
    this.loaderColour = Colors.pink,
    this.carousel = false,
  });

  final bool hasTitle;
  final int maxRewardNum;
  final Color loaderColour;
  final bool carousel;

  RichText _title(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        WidgetSpan(
          child: Icon(
            Icons.emoji_events_outlined,
            color: WanTheme.colors.orange,
          ),
        ),
        TextSpan(
          text: "Rewards",
          style: Theme.of(context)
              .textTheme
              .headline3!
              .copyWith(fontWeight: FontWeight.w500),
        ),
      ]),
    );
  }

  RichText _noRewardsText(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: "You have no rewards yet",
          style: Theme.of(context).textTheme.bodyText1),
    );
  }

  Widget _rewards(BuildContext context, List<Reward> rewards) {
    if (rewards.length == 0) {
      return Center(child: _noRewardsText(context));
    } else if (this.carousel) {
      return CarouselSlider.builder(
        itemBuilder: (BuildContext context, int i, int realIndex) {
          return Card(child: _RewardItem(rewards[i]));
        },
        options: CarouselOptions(
            autoPlay: true, enlargeCenterPage: true, height: 110),
        itemCount: rewards.length,
      );
    } else {
      return Container(
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: maxRewardNum == -1 ? rewards.length : maxRewardNum,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.all(0.0),
              child: _RewardItem(rewards[i]),
            );
          },
          separatorBuilder: (context, i) =>
              Padding(padding: EdgeInsets.only(bottom: 8.0)),
          physics: NeverScrollableScrollPhysics(),
        ),
      );
    }
  }

  Widget _listContainer(BuildContext context) {
    double topPadding = this.carousel ? 0.0 : 16.0;
    return BlocBuilder<RewardsListCubit, RewardsListState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.only(top: topPadding, bottom: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              hasTitle ? _title(context) : Container(),
              hasTitle
                  ? Padding(padding: EdgeInsets.only(top: 16))
                  : Container(),
              state is RewardsListLoaded
                  ? _rewards(context, state.rewards)
                  : Center(child: CircularProgressIndicator()),
            ],
          ),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          RewardsListCubit(RestUserRepository())..getUserRewards(),
      child: _listContainer(context),
    );
  }
}

Future<String> onRedeemPress(BuildContext context, Reward reward) async {
  return await context.read<RewardsListCubit>().redeemReward(reward);
}

class _RewardItem extends StatelessWidget {
  _RewardItem(this.reward);

  final Reward reward;

  @override
  Widget build(BuildContext context) {
    bool redeemed = reward.redemptionDate != null;
    BuildContext itemContext = context;
    _onPress() {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(WanTheme.CARD_CORNER_RADIUS),
          ),
          child: RewardDetailsPopup(
            reward.name,
            reward.imageUrl,
            "",
            reward.value,
            reward.location,
            () async {
              return onRedeemPress(itemContext, reward);
            },
            Navigator.of(context).pop,
            reward.redemptionDate == null
                ? RewardDetailsPopupStatus.Unredeemed
                : RewardDetailsPopupStatus.Success,
          ),
        ),
      );
    }

    return RewardCard(
      reward.name,
      reward.imageUrl,
      reward.value,
      reward.location,
      redeemed,
      _onPress,
    );
  }
}
