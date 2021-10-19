import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class Reward extends Equatable {
  Reward(this.id, this.redemptionDate, this.description, this.imageUrl,
      this.location, this.name, this.value);

  final String id;
  final DateTime? redemptionDate;
  final String description;
  final String imageUrl;
  final String location;
  final String name;
  final String value;

  static const datetimeFormat = "E, dd LLL y H:m:s";

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      json["reward"]["id"],
      json["date"] == ""
          ? null
          : DateFormat(datetimeFormat).parse(json["date"]),
      json["reward"]["description"],
      json["reward"]["image"],
      json["reward"]["location"],
      json["reward"]["name"],
      json["reward"]["value"],
    );
  }

  factory Reward.fromRewardOnlyJson(Map<String, dynamic> json) {
    return Reward(
      json["id"],
      null,
      json["description"],
      json["image"],
      json["location"],
      json["name"],
      json["value"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "date": redemptionDate == null
          ? ""
          : DateFormat(datetimeFormat).format(redemptionDate!),
      "reward": {
        "description": description,
        "id": id,
        "image": imageUrl,
        "location": location,
        "name": name,
        "value": value,
      }
    };
  }

  @override
  List<Object?> get props =>
      [redemptionDate, description, imageUrl, location, name, value];

  Reward copyWith({
    String? id,
    DateTime? redemptionDate,
    String? description,
    String? imageUrl,
    String? location,
    String? name,
    String? value,
  }) {
    return Reward(
      id ?? this.id,
      redemptionDate ?? this.redemptionDate,
      description ?? this.description,
      imageUrl ?? this.imageUrl,
      location ?? this.location,
      name ?? this.name,
      value ?? this.value,
    );
  }
}
