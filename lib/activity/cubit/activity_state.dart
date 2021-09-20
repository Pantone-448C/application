part of 'activity_cubit.dart';

abstract class ActivityState {}

class ActivityInitial implements ActivityState {}

class ActivityLoading implements ActivityState {}

class ActivityLoaded extends Equatable implements ActivityState {
  const ActivityLoaded(this.name, this.address, this.points, this.about);

  final String name;
  final String address;
  final int points;
  final String about;

  @override
  List<Object> get props => [name, address, points, about];
}
