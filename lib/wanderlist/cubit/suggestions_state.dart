import 'package:application/models/activity.dart';
import 'package:equatable/equatable.dart';

abstract class SuggestionsState {}

class Initial implements SuggestionsState {}

class Loading implements SuggestionsState {}

class Loaded implements SuggestionsState {
  Loaded(this.activities);

  final List<ActivityDetails> activities;
}
