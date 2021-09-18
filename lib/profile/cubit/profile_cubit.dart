import 'package:application/models/user.dart';
import 'package:application/profile/cubit/profile_state.dart';
import 'package:application/repositories/user/i_user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this.userRepository) : super(ProfileInitial()) {
    emit(ProfileInitial());
    getUserInfo();
  }

  final IUserRepository userRepository;

  Future<void> getUserInfo() async {
    UserDetails user = await userRepository.getUserData();
    emit(ProfileLoaded("Joe", "Biden", 69,
        "https://www.biography.com/.image/t_share/MTc0NjMzNDczMzM0NTg1MzM0/gettyimages-465470375.jpg"));
  }
}
