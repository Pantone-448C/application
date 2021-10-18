import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class Reward extends Equatable {
  Reward(this.redemptionDate, this.description, this.imageUrl, this.location,
      this.name, this.value);

  final DateTime? redemptionDate;
  final String description;
  final String imageUrl;
  final String location;
  final String name;
  final String value;

  factory Reward.fromJson(Map<String, dynamic> json) {
    final datetimeFormat = DateFormat("E, dd LLL y H:m:s");
    return Reward(
      datetimeFormat.parse(json["date"]),
      json["reward"]["description"],
      json["reward"]["image"],
      json["reward"]["location"],
      json["reward"]["name"],
      json["reward"]["value"],
    );
  }

  factory Reward.fromRewardOnlyJson(Map<String, dynamic> json) {
    return Reward(
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
      "date": redemptionDate,
      "description": description,
      "image": imageUrl,
      "location": location,
      "name": name,
      "value": value,
    };
  }

  @override
  List<Object?> get props =>
      [redemptionDate, description, imageUrl, location, name, value];

  Reward copyWith(
    DateTime? redemptionDate,
    String? description,
    String? imageUrl,
    String? location,
    String? name,
    String? value,
  ) {
    return Reward(
      redemptionDate ?? this.redemptionDate,
      description ?? this.description,
      imageUrl ?? this.imageUrl,
      location ?? this.location,
      name ?? this.name,
      value ?? this.value,
    );
  }
}
