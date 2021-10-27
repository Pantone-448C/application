import 'package:application/models/wanderlist.dart';

abstract class IWanderlistRepository {
  Future<Wanderlist> getWanderlist(String id);

  Future<void> setWanderlist(Wanderlist wanderlist);

  Future<Wanderlist> addWanderlist(Wanderlist wanderlist);
}
