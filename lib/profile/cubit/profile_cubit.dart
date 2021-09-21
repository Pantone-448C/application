import 'package:application/models/activity.dart';
import 'package:application/models/user.dart';
import 'package:application/profile/cubit/profile_state.dart';
import 'package:application/repositories/user/i_user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this.userRepository) : super(ProfileInitial()) {
    emit(ProfileInitial());
    getUserInfo();
  }

  final IUserRepository userRepository;

  Future<void> getUserInfo() async {
    UserDetails user = await userRepository.getUserData();
    Iterable<ActivityDetails> completed =
        await userRepository.getUserCompletedActivities();
    int points = 0;
    completed.forEach((activity) {
      points += activity.points;
    });
    emit(ProfileLoaded(user.firstName, user.lastName, points,
        "https://www.biography.com/.image/t_share/MTc0NjMzNDczMzM0NTg1MzM0/gettyimages-465470375.jpg"));
  }
}
