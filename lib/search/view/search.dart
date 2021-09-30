import 'package:application/components/activity_summary_item_small.dart';
import 'package:application/components/searchfield.dart';
import 'package:application/models/activity.dart';
import 'package:application/repositories/search/search_repository.dart';
import 'package:application/search/cubit/search_cubit.dart';
import 'package:application/search/cubit/search_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bottom_drawer/bottom_drawer.dart';


import '../../apptheme.dart';
import '../../sizeconfig.dart';


class _Drawer extends StatelessWidget {
  BottomDrawerController controller = BottomDrawerController();

  _Drawer(bool open) {
    if (open) controller.open();
  }

  @override
  Widget build(BuildContext context) {
    return BottomDrawer(
      body: _SearchPage(),
      header: Container(),
      headerHeight: 87,
      drawerHeight: 400,
      controller: controller,
    );
  }
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final qb = SearchCubit(SearchRepository());
    return BlocProvider(
      create: (context) => qb,
      child:
          Stack(children: <Widget> [
        Expanded(child: Center(child: Text("Map View"))),
          _Drawer(true)] ),
    );
  }
}

class _SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      buildWhen: (p, s) => p != s,
      builder: (context, state) {
        if (state is SearchSuggest) {
          return _ActivityPage( suggestions: state.suggestion, results: []);
        }
        if (state is SearchLoading) {
          return _ActivityPage( suggestions: state.suggestion, results: [], loading: true);
        }
        if (state is SearchResults) {
          return _ActivityPageResults( suggestions: state.suggestion, results: state.results);
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container (
      // search bar
      padding: EdgeInsets.symmetric(horizontal: WanTheme.CARD_PADDING,
          vertical: 2 * WanTheme.CARD_PADDING),
      child: TextField(
          keyboardType: TextInputType.text,
          onTap: () => context.read<SearchCubit>(),
          onChanged: (value) {
            context.read<SearchCubit>().search(value);
          },
          decoration: SearchField.defaultDecoration.copyWith(
            hintText: "Search Activities",
          )
      ),
    );
  }
}

class _ActivityPage extends StatelessWidget {
  final List<ActivityDetails> results;
  final List<ActivityDetails> suggestions;
  final bool loading;

  const _ActivityPage({Key? key, required this.results, required this.suggestions, this.loading = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var toShow;
    if (!loading) {
      toShow = List.of(this.results, growable: true);
    }

    toShow.addAll(suggestions);
    var resultList;
    if (loading)
      resultList = Expanded(child: Center(child: CircularProgressIndicator()));
    else
      resultList = Expanded(child: _ActivityList(activities: suggestions));


    return Container (
        padding: EdgeInsets.all(WanTheme.CARD_PADDING),
        child: Column (
        children: <Widget>[
          _SearchBar(),
          resultList
        ]));
  }
}
class _ActivityPageResults extends StatelessWidget {
  final List<ActivityDetails> results;
  final List<ActivityDetails> suggestions;

  const _ActivityPageResults({Key? key, required this.results, required this.suggestions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var toShow;
    toShow = List.of(results, growable: true);
    toShow.addAll(suggestions);
    var res;
    if (results.length == 0) {
      res = Expanded(child: Center(child: Text("No Results :(")));
    } else {
      res = Expanded(child: _ActivityList(activities: toShow));
    }

    return Container (
        padding: EdgeInsets.all(WanTheme.CARD_PADDING),
        child: Column (
            children: <Widget>[
              _SearchBar(),
              res,
            ]));
  }
}




class _ActivityList extends StatelessWidget {

  final activities;

  const _ActivityList({Key? key, this.activities}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (
    ListView.builder(
    itemCount: activities.length,
    itemBuilder: (BuildContext context, int index) =>
      ActivitySummaryItemSmall(activity: activities[index]))
    );
  }
}

