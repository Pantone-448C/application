import 'package:application/models/activity.dart';
import 'package:application/repositories/activity/i_activity_repository.dart';
import 'package:application/wanderlist/cubit/suggestions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SuggestionsCubit extends Cubit<SuggestionsState> {
  SuggestionsCubit(this.repository, String wanderlistId) : super(Initial(wanderlistId));

  final IActivityRepository repository;

  Future<void> loadSuggestions(String wanderlistId) async {
    if (state is Initial) {
      emit(Loading());
      List<ActivityDetails> activities = await repository.getSuggestForWanderlist(wanderlistId);
      emit(Loaded(activities));
    }
  }
}
