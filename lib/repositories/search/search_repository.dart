import 'dart:convert';
import 'dart:developer';

import 'package:application/activity/view/activity_info.dart';
import 'package:application/models/activity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'i_search_repository.dart';
import 'package:http/http.dart' as http;


class SearchRepository implements ISearchRepository {
  static const API_SCHEME = 'http';
  static const API_HOST = "189.254.206.35.bc.googleusercontent.com";
  static const API_PORT = 8080;
  static const API_BASE_PATH = "/activity";

  _responseToActivityList(String json) {
    // strongly assuming well-formed json
    var results = jsonDecode(json)["results"];
    results.map((json) => ActivityDetails.fromJson(json));
    List<ActivityDetails> l = List.empty(growable: true);
    results.forEach((element) => element["doc_id"] = element["id"]);
    results.forEach((element) => {l.add(ActivityDetails.fromJson(element))});
    return l;
  }

  _getToken() async {
    return {"authorization": await FirebaseAuth.instance.currentUser!.getIdToken()};
  }

  @override
  Future<List<ActivityDetails>> getNear(double lat, double lon, {double range=50}) async {
    final uri = Uri(
      scheme: API_SCHEME,
      host: API_HOST,
      path: API_BASE_PATH + "/near",
      port: API_PORT,
      queryParameters: {"lat": lat.toString(), "lon": lon.toString(), "range": range.toString()});

    final response = await http.get(uri, headers: _getToken());

    if (response.statusCode == 200) {
      return _responseToActivityList(response.body);
    }

    throw Exception(["Bad request"]);
  }

  @override
  Future<List<ActivityDetails>> getQuery(String query) async {
    final response = await http.get(Uri(
      scheme: API_SCHEME,
      host: API_HOST,
      path: API_BASE_PATH + "/search",
      port: API_PORT,
      queryParameters: {"query": query},
    ), headers: _getToken());

    if (response.statusCode == 200) {
      return _responseToActivityList(response.body);
    }

    throw Exception(["Bad request"]);
  }

}
