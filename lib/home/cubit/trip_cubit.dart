import 'package:application/models/activity.dart';
import 'package:application/models/wanderlist.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'trip_state.dart';

class TripCubit extends Cubit<TripState> {
  // TODO: Add a parameter to here after the repository pattern is implemented
  TripCubit() : super(TripInitial()) {
    emit(TripInitial());
    getTripInfo();
  }

  Future<void> getTripInfo() async {
    // TODO: Implement properly after implementing basic repository pattern
    // this is just a fake async call for testing.
    emit(TripLoading());
    await Future.delayed(Duration(seconds: 2));
    emit(TripLoaded("Brisbane", 3, 66, 1129, wanderlists));
  }
}

// Temporary data until we implement repositories - get rid of this before merging
final List<UserWanderlist> wanderlists = [
  UserWanderlist(
      0,
      0,
      7,
      Wanderlist(
          0,
          "Top 10 Eco-Lodges near Brisbane",
          <ActivityDetails>[
            ActivityDetails(
                "0",
                "Gwinganna Lifestyle Retreat",
                "about",
                "https://drive.google.com/uc?export=download&id=1k6CEDNmjY1RyUkwmAjujlgdSgtYWjXqv",
                "",
                "")
          ],
          "Creator Name")),
  UserWanderlist(
      0,
      0,
      7,
      Wanderlist(
          0,
          "Explore Stradbroke",
          <ActivityDetails>[
            ActivityDetails(
                "0",
                "Snorkelling at Moreton Bay",
                "about",
                "https://drive.google.com/uc?export=download&id=1k6CEDNmjY1RyUkwmAjujlgdSgtYWjXqv",
                "",
                "")
          ],
          "Creator Name"))
];
