import 'package:application/components/activity_summary_item_small.dart';
import 'package:application/components/searchfield.dart';
import 'package:application/models/activity.dart';
import 'package:application/pages/wanderlist/cubit/suggestions_cubit.dart';
import 'package:application/pages/wanderlist/cubit/suggestions_state.dart'
    as suggestionsState;
import 'package:application/pages/wanderlist/cubit/wanderlist_cubit.dart';
import 'package:application/pages/wanderlist/cubit/wanderlist_state.dart'
    as wanderlistState;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../apptheme.dart';

class AddActivityOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      minHeight: 65,
      backdropEnabled: true,
      parallaxEnabled: true,
      panel: Container(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0),
        child: Column(
          children: [
            Icon(Icons.horizontal_rule, color: WanColors().grey),
            Text("Find Activities",
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400)),
            Divider(),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
            ),
            SearchField("Search Activities"),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text("Suggestions",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.normal)),
            ),
            Container(height: 345, child: _Suggestions()),
          ],
        ),
      ),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(18.0),
        topRight: Radius.circular(18.0),
      ),
    );
  }
}

class _Suggestions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SuggestionsCubit, suggestionsState.SuggestionsState>(
      builder: (context, state) {
        if (state is suggestionsState.Initial) {
          context.read<SuggestionsCubit>().loadSuggestions();
        } else if (state is suggestionsState.Loading) {
          return CircularProgressIndicator();
        } else if (state is suggestionsState.Loaded) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.activities.length,
            itemBuilder: (context, index) {
              return _SuggestionsItem(state.activities[index]);
            },
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
          );
        }

        return CircularProgressIndicator();
      },
      listener: (context, state) => {},
    );
  }
}

class _SuggestionsItem extends StatelessWidget {
  _SuggestionsItem(this.activity);

  final ActivityDetails activity;

  Widget addButton(BuildContext context, wanderlistState.Editing state) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0.0,
        shadowColor: Colors.transparent,
      ),
      onPressed: () {
        context.read<WanderlistCubit>().addActivity(state.wanderlist, activity);
      },
      child: Text(
        "Add",
        style:
            TextStyle(fontSize: 10, fontFamily: "Inter", color: Colors.white),
      ),
    );
  }

  Widget successfullyAddedIcon() {
    return Container(
      width: 65,
      child: Text("Added!",
          style: TextStyle(
            fontSize: 12,
            fontFamily: "Inter",
            color: Colors.pink[300],
          )),
      alignment: Alignment.center,
    );
  }

  Widget pickItemIcon(BuildContext context, wanderlistState.Editing state) {
    if (state.wanderlist.activities
        .any((activity) => this.activity.id == activity.id)) {
      return successfullyAddedIcon();
    }

    return addButton(context, state);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WanderlistCubit, wanderlistState.WanderlistState>(
      builder: (context, state) {
        if (state is wanderlistState.Editing) {
          return Row(
            children: [
              Expanded(
                flex: 13,
                child: ActivitySummaryItemSmall(
                  activity: activity,
                  smallIcon: true,
                  rightWidget: Container(
                    height: 20,
                    child: pickItemIcon(context, state),
                  ),
                ),
              ),
              //
              // ))
            ],
          );
        }

        throw Exception("Impossible state");
      },
      listener: (context, state) {},
    );
  }
}
