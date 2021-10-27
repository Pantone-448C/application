import 'package:application/models/activity.dart';

/// IActivityRepository provides an interface for access to Activities in
/// Firestore or a local mock. Since the user can only access repository data
/// (and not edit it) there is only a single get method.
abstract class ISearchRepository {
  Future<List<ActivityDetails>> getNear(double lat, double lon,
      {double range = 50});

  Future<List<ActivityDetails>> getQuery(String query);
}
