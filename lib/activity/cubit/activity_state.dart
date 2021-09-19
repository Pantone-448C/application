import 'package:equatable/equatable.dart';

class ActivityState extends Equatable {
  ActivityState(this.name, this.address, this.points, this.about);

  String name;
  String address;
  int points;
  String about;
}
