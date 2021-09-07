import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'trip_state.dart';

class TripCubit extends Cubit<TripState> {
  // TODO: Add a parameter to here after the repository pattern is implemented
  TripCubit() : super(TripInitial());

  Future<void> getTripInfo() async {
    // TODO: Implement properly after implementing basic repository pattern
    // this is just a fake async call for testing.
    emit(TripLoading());
    await Future.delayed(Duration(seconds: 2));
    emit(TripLoaded(3, 66, 1129));
  }
}
