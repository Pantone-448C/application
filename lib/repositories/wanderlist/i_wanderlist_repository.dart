import 'package:application/models/user_wanderlist.dart';
import 'package:application/models/wanderlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IWanderlistRepository {
  Future<Wanderlist> getWanderlist(String id);
  Future<void> setWanderlist(Wanderlist wanderlist);
  Future<Wanderlist> addWanderlist(Wanderlist wanderlist);
}
