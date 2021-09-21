import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class ActivityDetails extends Equatable {
  ActivityDetails(this.id, this.name, this.about, this.thumbUrl, this.imageUrl,
      this.address, this.points);

  factory ActivityDetails.fromJson(Map<String, dynamic> json) =>
      ActivityDetails(
        json["doc_id"],
        json['name'],
        json['about'],
        json['thumb_url'],
        json['image_url'],
        json['address'],
        json['points'],
      );

  final String id;
  final String name;
  final String about;
  final String thumbUrl;
  final String imageUrl;
  final String address;
  final int points;

  @override
  List<Object?> get props =>
      [id, name, about, thumbUrl, imageUrl, address, points];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'about': about,
      'thumb_url': thumbUrl,
      'image_url': imageUrl,
      'address': address,
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
  }) {
    return ActivityDetails(
      id ?? this.id,
      name ?? this.name,
      about ?? this.about,
      thumbUrl ?? this.thumbUrl,
      imageUrl ?? this.imageUrl,
      address ?? this.address,
      points ?? this.points,
    );
  }
}
