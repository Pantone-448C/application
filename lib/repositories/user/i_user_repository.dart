import 'package:application/models/user.dart';
import 'package:application/models/user_wanderlist.dart';

abstract class IUserRepository {
  Future<UserDetails> getUserData();
  Future<Iterable<UserWanderlist>> getActiveWanderlists();
  Future<Iterable<UserWanderlist>> getUserWanderlists();

  Future<void> updateUserData(UserDetails details);
}
