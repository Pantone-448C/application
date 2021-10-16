import 'package:application/components/activity_summary_item_small.dart';
import 'package:application/components/searchfield.dart';
import 'package:application/pages/search/cubit/search_cubit.dart';
import 'package:application/pages/search/cubit/search_state.dart';
import 'package:application/pages/search/view/mapwidget.dart';
import 'package:application/repositories/search/search_repository.dart';
import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../apptheme.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final qb = SearchCubit(SearchRepository());
    return BlocProvider(
      create: (context) => qb,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          drawerScrimColor: Colors.transparent,
          body: Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Stack(children: <Widget>[
                MapSample(),
                _Drawer(),
                _ActivityPreview(),
              ]))),
    );
  }
}

class _Drawer extends StatelessWidget {
  BottomDrawerController controller = BottomDrawerController();

  @override
  Widget build(BuildContext context) {
    return BottomDrawer(
      body: _SearchPage(),
      header: Container(),
      headerHeight: 87,
      drawerHeight: 300,
      controller: controller,
    );
  }
}

class _ActivityPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(builder: (context, state) {
      if (state is SelectedActivity) {
        return Container(
            padding: EdgeInsets.all(WanTheme.CARD_PADDING),
            child: ActivitySummaryItemSmall(activity: state.activity));
      }

      return Container(height: 0);
    });
  }
}

class _SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(WanTheme.CARD_PADDING),
        child: Column(children: <Widget>[
          _SearchBar(),
          _ActivityPage(),
        ]));
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // search bar
      padding: EdgeInsets.symmetric(
          horizontal: WanTheme.CARD_PADDING,
          vertical: 2 * WanTheme.CARD_PADDING),
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
        ),
      ),
    );
  }
}

class _ActivityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
        buildWhen: (p, s) => s != p && !(s is MapState),
        builder: (context, state) {
          if (state is SearchLoading) {
            return Expanded(child: Center(child: CircularProgressIndicator()));
          }

          if (state is SearchInitial) {
            return Expanded(child: _ActivityList(activities: state.suggestion));
          }

          if (state is SearchResults) {
            return Expanded(child: _ActivityList(activities: state.results));
          }

          if (state is SearchSuggest) {
            return Expanded(
                child: Column(children: [
              Text("Nearby Activities"),
              Expanded(child: _ActivityList(activities: state.suggestion))
            ]));
          }

          return Expanded(child: Center(child: CircularProgressIndicator()));
        });
  }
}

class _ActivityList extends StatelessWidget {
  final activities;

  const _ActivityList({Key? key, this.activities}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (ListView.builder(
        itemCount: activities.length,
        itemBuilder: (BuildContext context, int index) => Container(
            padding: EdgeInsets.only(bottom: WanTheme.CARD_PADDING),
            child: ActivitySummaryItemSmall(activity: activities[index]))));
  }
}
