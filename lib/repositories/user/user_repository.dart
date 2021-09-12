import 'dart:developer';

import 'package:application/models/user.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'i_user_repository.dart';

class UserRepository implements IUserRepository {
  UserRepository() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var user = auth.currentUser;
    if (user != null) {
      _uid = user.uid;
    }
    _users = FirebaseFirestore.instance.collection('users');
  }

  late String _uid;
  late CollectionReference _users;

  @override
  Future<UserDetails> getUserData() async {
    DocumentSnapshot snapshot = await _users.doc(_uid).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    data['wanderlists'] = null;
    return UserDetails.fromJson(data);
  }

  @override
  Future<void> addNewUser(UserDetails details) async {
    // TODO: Implement this
    throw UnimplementedError(
        "Not implemented yet! Your changes weren't pushed to Firestore.");
  }

  @override
  Future<void> updateUserData(UserDetails details) async {}

  @override
  Future<Iterable<UserWanderlist>> getActiveWanderlists() async {
    Iterable<UserWanderlist> wanderlists = await getUserWanderlists();
    return wanderlists.where((wanderlist) => wanderlist.inTrip);
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
      data.add(refDocument.data() as Map<String, dynamic>);
    }

    return data;
  }
}
