import 'package:application/models/activity.dart';
import 'package:application/models/user.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

import 'i_user_repository.dart';
import 'package:http/http.dart' as http;

class UserRepository implements IUserRepository {

  _getToken() async {
    return {"authorization": await FirebaseAuth.instance.currentUser!.getIdToken()};
  }

  _Uri(String path, Map<String, dynamic> queryParams) {
    return Uri(
      scheme: API_SCHEME,
      host: API_HOST,
      path: path,
      port: API_PORT,
    );
  }

  Future<Map> _getDocument(Uri uri) async {
    print(uri);
    print(await _getToken());
    final response = await http.get(uri, headers: await _getToken());
    print(response);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception(["Bad request " + jsonDecode(response.body)["error"]]);
  }


  _getUser() async {

  }




  UserRepository() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    _setUser(auth, auth.currentUser);
    _users = FirebaseFirestore.instance.collection('users');
    _activities = FirebaseFirestore.instance.collection('activities');
    auth.authStateChanges().listen((newUser) => _setUser(auth, newUser));
  }

  static const API_SCHEME = 'http';
  static const API_HOST = "192.168.0.36";
  static const API_PORT = 8080;

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
    var data = await _getDocument(_Uri("user", {})) as Map<String, dynamic>;
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
    print(await _getToken());
    var headers =await _getToken();
    headers["content-type"] = "application/json";
    final response = await http.post(_Uri("user",{}),
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
    _users.doc(_uid).update({
      "completed_activities":
          list.map((activity) => _activities.doc(activity.id)).toList(),
    });
  }

  Future<ActivityDetails> getActivity(String id) async {

    Map<String, dynamic> data = await _getDocument(_Uri("activity/$id", {})) as Map<String, dynamic>;
    data["id"] = id;
    return ActivityDetails.fromJson(data);
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
