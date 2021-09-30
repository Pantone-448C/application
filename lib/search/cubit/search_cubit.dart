import 'dart:async';
import 'dart:developer';

import 'package:application/models/user.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:application/models/wanderlist.dart';
import 'package:application/repositories/search/i_search_repository.dart';
import 'package:application/repositories/user/i_user_repository.dart';
import 'package:application/repositories/wanderlist/i_wanderlist_repository.dart';
import 'package:application/search/cubit/search_state.dart';
import 'package:application/userwanderlists/cubit/userwanderlists_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  Future<void> search(String query) async {

    final results = await searchRepository.getQuery(query);
    emit(SearchResults(results, state.suggestion));
  }


// delete()

// add()

}
