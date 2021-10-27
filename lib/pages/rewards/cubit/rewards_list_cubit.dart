
import 'package:application/models/reward.dart';
import 'package:application/pages/rewards/cubit/rewards_list_state.dart';
import 'package:application/repositories/user/i_user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RewardsListCubit extends Cubit<RewardsListState> {
  RewardsListCubit(this.userRepository) : super(RewardsListInitial());

  final IUserRepository userRepository;

  Future<void> getUserRewards() async {
    emit(RewardsListLoading());
    List<Reward> rewards = (await userRepository.getUserRewards()).toList();
    emit(RewardsListLoaded(rewards));
  }

  Future<String> redeemReward(Reward reward) async {
    if (state is RewardsListLoaded) {
      Reward redeemed = reward.copyWith(redemptionDate: DateTime.now());
      List<Reward> rewards = (state as RewardsListLoaded).rewards;
      for (int i = 0; i < rewards.length; i++) {
        if (redeemed.id == rewards[i].id) {
          rewards[i] = redeemed;
        }
      }
      await userRepository.updateReward(redeemed);
      emit(RewardsListLoaded(rewards));
      return redeemed.getRedemptionDateAsString();
    }

    return "";
  }
}
