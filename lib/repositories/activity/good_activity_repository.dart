import 'dart:developer';

import 'package:application/models/activity.dart';
import 'package:application/repositories/activity/i_activity_repository.dart';
import 'package:application/repositories/search/search_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../rest_api.dart';

class GoodActivityRepository implements IActivityRepository {

  @override
  Future<ActivityDetails> getActivity(String id) async {
    var data = await getDocument(restUri("activities/" + id, {})) as Map<String, dynamic>;
    print(data);
    return ActivityDetails.fromJson(data);
  }

  @override
  Future<List<ActivityDetails>> getActivities() async {
    log("test");
    var data = await getDocument(restUri("activities", {"rec": "yes"})) as Map<String, dynamic>;
    List<ActivityDetails> activities = List.empty(growable: true);
    data["results"].forEach((json) => activities.add(ActivityDetails.fromJson(json)));
    return activities;
  }
}
