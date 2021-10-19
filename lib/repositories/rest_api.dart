import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

const API_SCHEME = 'http';
const API_HOST = "189.254.206.35.bc.googleusercontent.com";
const API_PORT = 8080;

getToken() async {
  return {
    "authorization": await FirebaseAuth.instance.currentUser!.getIdToken()
  };
}

restUri(String path, Map<String, dynamic> queryParams) {
  return Uri(
    scheme: API_SCHEME,
    host: API_HOST,
    path: path,
    port: API_PORT,
    queryParameters: queryParams,
  );
}

Future<Map> getDocument(Uri uri) async {
  return await getDyanmicDocument(uri) as Map;
}

Future<dynamic> getDyanmicDocument(Uri uri) async {
  var response = await http.get(uri, headers: await getToken());
  int tries = 0;
  while (response.statusCode != 200 && tries++ < 3) {
    print("Request failed retry $tries, $response.body");
    await Future.delayed(Duration(milliseconds: 100));
    response = await http.get(uri, headers: await getToken());
  }

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }

  throw Exception(["Bad request " + jsonDecode(response.body)["error"]]);
}

Future<void> postDocument(Uri uri, Map doc) async {
  var headers = await getToken();
  headers["content-type"] = "application/json";
  final response =
      await http.post(uri, headers: headers, body: json.encode(doc));

  if (response.statusCode != 200) {
    throw Exception(["Bad request " + jsonDecode(response.body)["error"]]);
  }
}

Future<Map> createDocument(Uri uri, Map doc) async {
  var headers = await getToken();
  headers["content-type"] = "application/json";
  final response =
      await http.post(uri, headers: headers, body: json.encode(doc));

  if (response.statusCode != 200) {
    throw Exception(["Bad request " + jsonDecode(response.body)["error"]]);
  }

  return jsonDecode(response.body);
}
