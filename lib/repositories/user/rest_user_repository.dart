import 'dart:developer';

import 'package:application/models/activity.dart';
import 'package:application/models/reward.dart';
import 'package:application/models/user.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:application/repositories/activity/rest_activity_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

import 'i_user_repository.dart';
import 'package:http/http.dart' as http;
import '../rest_api.dart';

class RestUserRepository implements IUserRepository {
  RestUserRepository() {
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

  static final isUserRewardsEndpointImplemented = true;

  @override
  Future<UserDetails> getUserData() async {
    var data = await getDocument(restUri("user", {})) as Map<String, dynamic>;
    return UserDetails.fromJson(data);
  }

  @override
  Future<Iterable<Reward>> getUserRewards() async {
    Map<String, dynamic> user =
        await getDocument(restUri("user", {})) as Map<String, dynamic>;
    return (user["rewards"] as List)
        .map((reward) => Reward.fromJson(reward as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<int> getPointsForNextReward() async {
    return await getDynamicDocument(restUri("user/rewards/totalpoints", {}))
        as int;
  }

  @override
  Future<Reward> getRecommendedReward() async {
    Map<String, dynamic> reward =
        await getDocument(restUri("user/rewards/next", {}))
            as Map<String, dynamic>;
    return Reward.fromRewardOnlyJson(reward);
  }

  @override
  Future<void> addReward(Reward reward) async {
    if (isUserRewardsEndpointImplemented) {
      List<Map> rewards =
          (await getUserRewards()).map((reward) => reward.toJson()).toList();
      rewards.add(reward.toJson());
      await postDocument(restUri("user/rewards", {}), {"rewards": rewards});
    } else {
      throw new UnimplementedError(
          "This method is not fully implemented yet, use updateUserDate");
    }
  }

  @override
  Future<void> updateReward(Reward reward) async {
    if (isUserRewardsEndpointImplemented) {
      List<Reward> rewards = (await getUserRewards()).toList();
      for (int i = 0; i < rewards.length; i++) {
        if (rewards[i].id == reward.id) {
          rewards[i] = reward;
        }
      }
      List<Map<String, dynamic>> jsonRewards =
          rewards.map((reward) => reward.toJson()).toList();

      // work around until the reward endpoint is actually implemented
      Map<String, dynamic> data = (await getUserData()).toJson();
      data["rewards"] = jsonRewards;
      var headers = await getToken();
      headers["content-type"] = "application/json";
      await http.post(restUri("user", {}),
          headers: headers, body: json.encode(data));
    } else {
      throw new UnimplementedError(
          "This method is not fully implemented yet, use updateUserDate");
    }
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
    var headers = await getToken();
    headers["content-type"] = "application/json";
    final response = await http.post(restUri("user", {}),
        headers: headers, body: json.encode(details.toJson()));

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
    return RestActivityRepository().getActivity(id);
  }

  @override
  Future<Iterable<UserWanderlist>> getActiveWanderlists() async {
    Iterable<UserWanderlist> wanderlists = await getUserWanderlists();
    return wanderlists.where((wanderlist) => wanderlist.inTrip);
  }

  @override
  Future<Iterable<ActivityDetails>> getUserCompletedActivities() async {
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


  @override
  Future<List<ActivityDetails>> getRecc() async {
    var data = await getDocument(restUri("activities", {"rec": "yes"})) as Map<String, dynamic>;
    var results = data["results"];
    results.map((json) => ActivityDetails.fromJson(json));
    List<ActivityDetails> l = List.empty(growable: true);
    results.forEach((element) => {l.add(ActivityDetails.fromJson(element))});
    return l;

  }





}
