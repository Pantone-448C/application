import 'package:application/models/activity.dart';

/// IActivityRepository provides an interface for access to Activities in
/// Firestore or a local mock. Since the user can only access repository data
/// (and not edit it) there is only a single get method.
abstract class IActivityRepository {
  Future<ActivityDetails> getActivity(String id);
  Future<List<ActivityDetails>> getActivities();
}
