import 'package:application/components/activity_summary_item_small.dart';
import 'package:application/components/searchfield.dart';
import 'package:application/repositories/search/search_repository.dart';
import 'package:application/search/cubit/search_cubit.dart';
import 'package:application/search/cubit/search_state.dart';
import 'package:application/search/view/mapwidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../apptheme.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final qb = SearchCubit(SearchRepository());
    return BlocProvider(
      create: (context) => qb,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          drawerScrimColor: Colors.transparent,
          body: SlidingUpPanel(
            panelBuilder: (ScrollController sc) => _SearchPage(sc),
            body: Container(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Stack(children: <Widget>[
                  MapSample(),
                  _ActivityPreview(),
                  _SearchBar(),
                ])),
          )),
    );
  }
}

class _ActivityPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(builder: (context, state) {
      if (state is SelectedActivity) {
        return Container(
          padding: EdgeInsets.only(
            left: WanTheme.CARD_PADDING,
            right: WanTheme.CARD_PADDING,
            top: WanTheme.CARD_PADDING + 75, // searchbar height
            bottom: WanTheme.CARD_PADDING,
          ),
          child: Material(
            elevation: 3,
            borderRadius:
                BorderRadius.all(Radius.circular(WanTheme.CARD_CORNER_RADIUS)),
            child: ActivitySummaryItemSmall(activity: state.activity),
          ),
          decoration: BoxDecoration(),
        );
      }

      return Container(height: 0);
    });
  }
}

class _SearchPage extends StatelessWidget {
  final ScrollController sc;
  _SearchPage(this.sc);
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(),
        padding: EdgeInsets.all(WanTheme.CARD_PADDING),
        child: Column(children: <Widget>[
          _ActivityPage(sc),
        ]));
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        // search bar
        padding: EdgeInsets.only(
          left: WanTheme.CARD_PADDING,
          right: WanTheme.CARD_PADDING,
          top: 2 * WanTheme.CARD_PADDING,
          bottom: 2 * WanTheme.CARD_PADDING,
        ),
        child: Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(25.0),
          child: TextField(
            keyboardType: TextInputType.text,
            onTap: () => context.read<SearchCubit>(),
            onChanged: (value) => context.read<SearchCubit>().search(value),
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                context.read<SearchCubit>().search(value);
              } else {
                context.read<SearchCubit>().suggestNearby();
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              }
            },
            decoration: SearchField.defaultDecoration.copyWith(
              hintText: "Search Activities",
              fillColor: WanColors().white,
            ),
          ),
        ),
      ),
    );
  }
}

class _ActivityPage extends StatelessWidget {
  final ScrollController sc;
  _ActivityPage(this.sc);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
        buildWhen: (p, s) => s != p && !(s is MapState),
        builder: (context, state) {
          if (state is SearchLoading) {
            return Expanded(child: Center(child: CircularProgressIndicator()));
          }

          if (state is SearchInitial) {
            return Expanded(
                child: _ActivityList(sc, activities: state.suggestion));
          }

          if (state is SearchResults) {
            return Expanded(
                child: Column(children: [
              Icon(Icons.horizontal_rule, color: WanColors().grey),
              Text("Search results",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Expanded(child: _ActivityList(sc, activities: state.results)),
            ]));
          }

          if (state is SearchSuggest) {
            return Expanded(
                child: Column(children: [
              Icon(Icons.horizontal_rule, color: WanColors().grey),
              Text("Nearby Activities",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Expanded(child: _ActivityList(sc, activities: state.suggestion))
            ]));
          }

          return Expanded(child: Center(child: CircularProgressIndicator()));
        });
  }
}

class _ActivityList extends StatelessWidget {
  final activities;
  final ScrollController sc;

  const _ActivityList(this.sc, {Key? key, this.activities}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (ListView.builder(
        controller: this.sc,
        itemCount: activities.length,
        itemBuilder: (BuildContext context, int index) => Container(
            padding: EdgeInsets.only(bottom: WanTheme.CARD_PADDING),
            child: ActivitySummaryItemSmall(activity: activities[index]))));
  }
}
