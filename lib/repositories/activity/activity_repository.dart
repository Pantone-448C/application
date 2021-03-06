
import 'package:application/models/activity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/* deprecated */

class ActivityRepository {
  final CollectionReference _activities =
      FirebaseFirestore.instance.collection('activities');

  @override
  Future<ActivityDetails> getActivity(String id) async {
    DocumentSnapshot snapshot = await _activities.doc(id).get();
    if (snapshot.exists) {
      var data = snapshot.data() as Map<String, dynamic>;
      data["id"] = id;
      return ActivityDetails.fromJson(data);
    } else {
      throw Exception(["Failed to get activity $id"]);
    }
  }

  @override
  Future<List<ActivityDetails>> getActivities() async {
    QuerySnapshot<Object?> snapshot = await _activities.limit(50).get();
    List<ActivityDetails> activities =
        snapshot.docs.map((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      data["id"] = doc.id;
      return ActivityDetails.fromJson(data);
    }).toList();
    return activities;
  }
}
