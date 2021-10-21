import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

@immutable
class ActivityDetails extends Equatable {
  ActivityDetails(this.id, this.name, this.about, this.thumbUrl, this.imageUrl,
      this.address, this.points, this.tags);

  factory ActivityDetails.fromJson(Map<String, dynamic> json) {

    var a = ActivityDetails(
      json["id"],
      json['name'],
      json['about'],
      json['thumb_url'],
      json['image_url'],
      json['address'],
      json['points'],
      json['tags'],
    );

    if (json.containsKey("location")) {
      if (json["location"] is GeoPoint) {
        // is GeoPoint from firebase
        a.location = LatLng(json["location"].latitude, json["location"].longitude);
      }
      else if (json["location"].containsKey("type")) {
        // is GeoJSON from mongo db
        a.location = LatLng(json['location']["coordinates"][1],
            json["location"]['coordinates'][0]);
      } else {
        throw Exception(["Activity with invalid location"]);
      }
    }

    return a;
  }

  final String id;
  final String name;
  final String about;
  final String thumbUrl;
  final String imageUrl;
  final String address;
  final List<dynamic> tags;
  final int points;
  late final LatLng location;

  @override
  List<Object?> get props =>
      [id, name, about, thumbUrl, imageUrl, address, points];


  Map<String, dynamic> toRef() {
    return {
      'ref': "activities/" + id,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'about': about,
      'thumb_url': thumbUrl,
      'image_url': imageUrl,
      'address': address,
      'tags': tags,
    };
  }

  ActivityDetails copyWith({
    String? id,
    String? name,
    String? about,
    String? thumbUrl,
    String? imageUrl,
    String? address,
    int? points,
    List<dynamic>? tags,
  }) {
    return ActivityDetails(
      id ?? this.id,
      name ?? this.name,
      about ?? this.about,
      thumbUrl ?? this.thumbUrl,
      imageUrl ?? this.imageUrl,
      address ?? this.address,
      points ?? this.points,
      tags?? this.tags,
    );
  }
}
