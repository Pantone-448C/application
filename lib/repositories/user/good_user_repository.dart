import 'package:application/models/activity.dart';
import 'package:application/models/user.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:application/repositories/activity/good_activity_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

import 'i_user_repository.dart';
import 'package:http/http.dart' as http;
import '../rest_api.dart';

class GoodUserRepository implements IUserRepository {


  GoodUserRepository() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    _setUser(auth, auth.currentUser);
    auth.authStateChanges().listen((newUser) => _setUser(auth, newUser));
  }


  _setUser(auth, user) {
    if (user != null) {
      _uid = user.uid;
    }
  }

  late String _uid;
  late CollectionReference _users;
  late CollectionReference _activities;

  @override
  Future<UserDetails> getUserData() async {
    var data = await getDocument(restUri("user", {})) as Map<String, dynamic>;
    return UserDetails.fromJson(data);
  }

  @override
  Future<void> addNewUser(UserDetails details) async {
    // TODO: Implement this
    throw UnimplementedError(
        "Not implemented yet! Your changes weren't pushed to Firestore.");
  }

  @override
  Future<void> updateUserData(UserDetails details) async {
    print(await getToken());
    var headers =await getToken();
    headers["content-type"] = "application/json";
    final response = await http.post(restUri("user",{}),
        headers: headers,
        body: json.encode(details.toJson()));

    print(response);

    if (response.statusCode != 200) {
      throw Exception(["Bad request " + jsonDecode(response.body)["error"]]);
    }
  }

  @override
  Future<void> updateUserWanderlists(List<UserWanderlist> list) async {
    var details = await getUserData();
    details.wanderlists = list;
    updateUserData(details);
  }

  @override
  Future<void> updateUserCompletedActivities(List<ActivityDetails> list) async {

    var details = await getUserData();
    details.completedActivities = list;
    return updateUserData(details);
  }

  Future<ActivityDetails> getActivity(String id) async {
    return GoodActivityRepository().getActivity(id);
  }

  @override
  Future<Iterable<UserWanderlist>> getActiveWanderlists() async {
    Iterable<UserWanderlist> wanderlists = await getUserWanderlists();
    return wanderlists.where((wanderlist) => wanderlist.inTrip);
  }

  @override
  Future<Iterable<ActivityDetails>> getUserCompletedActivities() async {
    //var data = snapshot.data() as Map<String, dynamic>;
    //Map<String, dynamic> data = await _getDocument(_Uri("user", {})) as Map<String, dynamic>;

    var data = await getUserData();
    return data.completedActivities;
  }

  @override
  Future<Iterable<UserWanderlist>> getUserWanderlists() async {
    var data = await getUserData();
    return data.wanderlists;
  }


  @override
  Future<void> addUserWanderlist(UserWanderlist wanderlist) async {
    var details = await getUserData();
    details.wanderlists.add(wanderlist);
    await updateUserData(details);
  }
}
