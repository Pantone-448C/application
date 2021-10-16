part of 'activity_cubit.dart';

abstract class ActivityState {}

class ActivityInitial implements ActivityState {}

class ActivityLoading implements ActivityState {}

class ActivityLoaded implements ActivityState {
  const ActivityLoaded(
      this.name, this.address, this.points, this.about, this.imgUrl);
  final String name;
  final String address;
  final int points;
  final String about;
  final String imgUrl;
}
