import 'package:application/models/wanderlist.dart';

abstract class IWanderlistRepository {
  Future<Wanderlist> getWanderlist(String id);
}
