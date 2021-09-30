import 'dart:async';

import 'package:application/repositories/search/i_search_repository.dart';
import 'package:application/search/cubit/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class SearchCubit extends Cubit<SearchState> {
  final ISearchRepository searchRepository;
  static const timeout = Duration(seconds: 1);

  SearchCubit(this.searchRepository) : super(SearchInitial()) {
    suggest();
  }

  Future<void> suggest() async {
    emit(SearchSuggest([]));
  }

  void _showLoading() {
    emit(SearchLoading(state.suggestion));
  }

  Future<void> suggestNearby() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    var pos = await Geolocator.getCurrentPosition();

    var res = searchRepository.getNear(pos.latitude, pos.longitude, range: 500);



  }

  Future<void> search(String query) async {

    final results = await searchRepository.getQuery(query);
    emit(SearchResults(results, state.suggestion));
  }


// delete()

// add()

}
