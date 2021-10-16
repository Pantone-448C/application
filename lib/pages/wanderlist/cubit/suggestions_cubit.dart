import 'package:application/models/activity.dart';
import 'package:application/pages/wanderlist/cubit/suggestions_state.dart';
import 'package:application/repositories/activity/i_activity_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SuggestionsCubit extends Cubit<SuggestionsState> {
  SuggestionsCubit(this.repository) : super(Initial());

  final IActivityRepository repository;

  Future<void> loadSuggestions() async {
    if (state is Initial) {
      emit(Loading());
      List<ActivityDetails> activities = await repository.getActivities();
      emit(Loaded(activities));
    }
  }
}
