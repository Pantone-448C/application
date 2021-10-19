import 'package:application/models/reward.dart';
import 'package:application/repositories/user/i_user_repository.dart';
import 'package:application/rewards/cubit/rewards_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RewardsListCubit extends Cubit<RewardsListState> {
  RewardsListCubit(this.userRepository) : super(RewardsListInitial());

  final IUserRepository userRepository;

  Future<void> getUserRewards() async {
    emit(RewardsListLoading());
    List<Reward> rewards = (await userRepository.getUserRewards()).toList();
    emit(RewardsListLoaded(rewards));
  }
}
