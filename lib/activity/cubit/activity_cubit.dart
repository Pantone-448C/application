import 'package:application/activity/view/activity_info.dart';
import 'package:application/models/activity.dart';
import 'package:application/repositories/activity/i_activity_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:geocoding/geocoding.dart';
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

  Future<void> launchMaps() async {
    print("beep");
    ActivityDetails a = await activityRepository.getActivity(id);
    print("beep");
    List<Location> locations = await locationFromAddress(a.address);
    var coords = Coords(locations.first.latitude, locations.first.longitude);
    final availableMaps = await MapLauncher.installedMaps;
    await availableMaps.first.showDirections(
      destination: coords,
      destinationTitle: a.name,
    );
  }
}
