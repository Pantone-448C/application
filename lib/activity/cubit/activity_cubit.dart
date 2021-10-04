import 'package:application/models/activity.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:application/models/wanderlist.dart';
import 'package:application/repositories/activity/i_activity_repository.dart';
import 'package:application/repositories/wanderlist/i_wanderlist_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'activity_state.dart';

class ActivityCubit extends Cubit<ActivityState> {
  ActivityCubit(
    this.activityRepository,
    this.id,
  ) : super(ActivityInitial()) {
    emit(ActivityInitial());
    getActivityInfo();
  }

  final IActivityRepository activityRepository;
  final String id;

  Future<void> getActivityInfo() async {
    var a = await activityRepository.getActivity(id);
    emit(ActivityLoaded(a.name, a.address, 100, a.about, a.imageUrl));
  }
}
