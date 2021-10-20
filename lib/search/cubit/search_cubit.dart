import 'dart:async';

import 'package:application/models/activity.dart';
import 'package:application/repositories/position/position.dart';
import 'package:application/repositories/search/i_search_repository.dart';
import 'package:application/search/cubit/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class SearchCubit extends Cubit<SearchState> {
  final ISearchRepository searchRepository;
  late Position userPosition;
  static const timeout = Duration(seconds: 1);

  SearchCubit(this.searchRepository) : super(SearchInitial()) {
    suggestNearby();
  }

  Future<void> _getUserPosition() async {
    var currentState = state;
    userPosition = await GPSPosition().getPosition();
    emit(GotUserPosition(userPosition));
  }

  void _showLoading() {
    emit(SearchLoading(state.suggestion));
  }

  Future<void> suggestNearby() async {
    await _getUserPosition();
    var res = await searchRepository
        .getNear(userPosition.latitude, userPosition.longitude, range: 50);
    emit(SearchSuggest(res));
  }

  Future<void> search(String query) async {
    if (query == "") {
      suggestNearby();
      return;
    }

    final results = await searchRepository.getQuery(query);
    emit(SearchResults(results, state.suggestion));
  }

  Future<void> selectActivity(ActivityDetails a) async {
    if (state is SelectedActivity) {
      SelectedActivity s = state as SelectedActivity;
      if (s.activity == a) {
        emit(NoActivitySelected());
        return;
      }
    }

    emit(SelectedActivity(a));
  }
// delete()

// add()

}
