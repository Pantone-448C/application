import 'package:application/models/activity.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'search_cubit.dart';

abstract class SearchState{
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

