import 'package:application/models/activity.dart';
import 'package:application/models/user.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'i_user_repository.dart';

class UserRepository implements IUserRepository {
  UserRepository() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    _setUser(auth, auth.currentUser);
    _users = FirebaseFirestore.instance.collection('users');
    _activities = FirebaseFirestore.instance.collection('activities');
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
    DocumentSnapshot snapshot = await _users.doc(_uid).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    data['wanderlists'] = null;
    data['completed_activities'] = null;
    return UserDetails.fromJson(data);
  }

  @override
  Future<UserDetails> getUserDataAndWanderlists() async {
    DocumentSnapshot snapshot = await _users.doc(_uid).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    print("User json in: $data");
    data['wanderlists'] = null;
    data['completed_activities'] = null;
    var details = UserDetails.fromJson(data);
    details.wanderlists = (await getUserWanderlists()).toList();
    return details;
  }

  @override
  Future<void> addNewUser(UserDetails details) async {
    // TODO: Implement this
    throw UnimplementedError(
        "Not implemented yet! Your changes weren't pushed to Firestore.");
  }

  @override
  Future<void> updateUserData(UserDetails details) async {
    _users.doc(_uid).update(details.toJson());
  }

  Future<void> updateUserWanderlists(UserDetails details) async {
    try {
      _users.doc(_uid).set(details.toJson());
    } catch (e) {
      print("Exception $e");
    }
  }

  Future<ActivityDetails> getActivity(String id) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('activities').doc(id).get();
    var data = snapshot.data() as Map<String, dynamic>;
    data["doc_id"] = id;
    return ActivityDetails.fromJson(data);
  }

  @override
  Future<Iterable<UserWanderlist>> getActiveWanderlists() async {
    Iterable<UserWanderlist> wanderlists = await getUserWanderlists();
    return wanderlists.where((wanderlist) => wanderlist.inTrip);
  }

  @override
  Future<Iterable<ActivityDetails>> getUserCompletedActivities() async {
    var snapshot = await _users.doc(_uid).get();
    var data = snapshot.data() as Map<String, dynamic>;
    if (data['completed_activities'] != null) {
      var completedActivities = hydrateReferences(
              List<DocumentReference>.from(data['completed_activities']))
          .then((activities) {
        return activities.map((activity) => ActivityDetails.fromJson(activity));
      });
      return completedActivities;
    }
    return [];
  }

  @override
  Future<Iterable<UserWanderlist>> getUserWanderlists() async {
    return _users.doc(_uid).get().then((snapshot) async {
      final data = snapshot.data() as Map<String, dynamic>;
      List<Map<String, dynamic>> wanderlists = [];
      if (data['wanderlists'] != null) {
        // Note: this is probably inefficient but it does the job for now.
        // Populate each of the user's wanderlists with the wanderlist reference
        // stored and the activities within that wanderlist.
        for (Map<String, dynamic> userWanderlist in data['wanderlists']) {
          DocumentSnapshot wanderlist =
              await userWanderlist['wanderlist'].get();

          Map<String, dynamic> wanderlistData =
              wanderlist.data() as Map<String, dynamic>;

          List<Map<String, dynamic>> completedActivities =
              await hydrateReferences(List<DocumentReference>.from(
                  userWanderlist['completed_activities']));
          // Get each of the activities referenced in the wanderlist and
          // replace the list of references currently held in the Map.
          List<Map<String, dynamic>> wanderlistActivities =
              await hydrateReferences(
                  List<DocumentReference>.from(wanderlist['activities']));

          userWanderlist['completed_activities'] = completedActivities;

          wanderlistData['activities'] = wanderlistActivities;
          wanderlistData["doc_ref"] = wanderlist.id;
          userWanderlist['wanderlist'] = wanderlistData;

          wanderlists.add(userWanderlist);
        }
      }

      data['wanderlists'] = wanderlists;
      return data['wanderlists'].map<UserWanderlist>(
          (wanderlist) => UserWanderlist.fromJson(wanderlist));
    });
  }

  Future<List<Map<String, dynamic>>> hydrateReferences(
      List<DocumentReference> refs) async {
    List<Map<String, dynamic>> data = [];
    for (DocumentReference ref in refs) {
      DocumentSnapshot refDocument = await ref.get();
      Map<String, dynamic> document =
          refDocument.data() as Map<String, dynamic>;
      document["doc_id"] = ref.id;
      data.add(document);
    }

    return data;
  }
}
