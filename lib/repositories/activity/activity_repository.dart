import 'package:application/models/activity.dart';
import 'package:application/repositories/activity/i_activity_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityRepository implements IActivityRepository {
  final CollectionReference _activities =
      FirebaseFirestore.instance.collection('activity');

  @override
  Future<ActivityDetails> getActivity(String id) async {
    DocumentSnapshot snapshot = await _activities.doc(id).get();
    return ActivityDetails.fromJson(snapshot.data() as Map<String, dynamic>);
  }
}
