import 'package:application/models/activity.dart';
import 'package:geolocator/geolocator.dart';

abstract class SearchState {
  const SearchState();

  List<ActivityDetails> get suggestion => [];
}

class SearchInitial implements SearchState {
  const SearchInitial();

  @override
  List<ActivityDetails> get suggestion => [];
}

class SearchLoading implements SearchState {
  final List<ActivityDetails> suggestion;

  SearchLoading(this.suggestion);
}

class SearchSuggest implements SearchState {
  final List<ActivityDetails> suggestion;

  SearchSuggest(this.suggestion);
}

class SearchResults implements SearchState {
  final List<ActivityDetails> results;
  final List<ActivityDetails> suggestion;

  SearchResults(this.results, this.suggestion);
}

abstract class MapState implements SearchState {
  @override
  List<ActivityDetails> get suggestion => [];
}

class GotUserPosition extends MapState {
  final Position userPosition;

  GotUserPosition(this.userPosition);
}

class NoActivitySelected extends MapState {
  NoActivitySelected();
}

class SelectedActivity extends MapState {
  final ActivityDetails activity;

  SelectedActivity(this.activity);
}
