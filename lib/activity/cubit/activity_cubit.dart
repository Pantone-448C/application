import 'package:application/models/activity.dart';
import 'package:application/repositories/activity/i_activity_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'activity_state.dart';

class ActivityCubit extends Cubit<ActivityState> {
  ActivityCubit(this.activityRepository, this.id) : super(ActivityInitial()) {
    emit(ActivityInitial());
    getActivityInfo();
  }

  final IActivityRepository activityRepository;
  final String id;

  Future<void> getActivityInfo() async {
    ActivityDetails a = await activityRepository.getActivity(id);
    emit(ActivityLoaded(a.name, a.address, 100, a.about, a.imageUrl));
  }

}
