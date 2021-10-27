import 'package:application/apptheme.dart';
import 'package:application/components/activity_summary_item_small.dart';
import 'package:application/components/searchfield.dart';
import 'package:application/models/activity.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:application/models/wanderlist.dart';
import 'package:application/repositories/wanderlist/wanderlist_repository.dart';
import 'package:application/pages/wanderlist/cubit/wanderlist_cubit.dart';
import 'package:application/pages/wanderlist/cubit/wanderlist_state.dart';
import 'package:application/pages/wanderlist/widgets/add_activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditWanderlistPage extends StatelessWidget {
  EditWanderlistPage(this.wanderlist);

  final Wanderlist wanderlist;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _AppBar(), body: _EditWanderlistBody());
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  _AppBar();

  static const barHeight = WanTheme.TITLEBAR_HEIGHT;
  @override
  Size get preferredSize => Size.fromHeight(barHeight);

  Widget _cancelButton(BuildContext context) {
    return TextButton (
      child: Row(children: [Icon(Icons.arrow_back, color: Theme.of(context).accentColor),
        Text(" Cancel"),
      ]),
      onPressed: () {
         context.read<WanderlistCubit>().cancelEdit();
         Navigator.of(context).pop(true);
      },
    );
  }

  Widget _saveButton(BuildContext context) {
    return TextButton (
        onPressed: () {
          context.read<WanderlistCubit>().endEdit();
          Navigator.of(context).pop(true);
        },
        child: Row (children: [Icon(Icons.check_rounded),
          Text("  Save")]));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WanderlistCubit, WanderlistState>(
      listener: (context, state) => {},
      builder: (context, state) {
        if (state is Editing) {
          if (state.isChanged) {
            return AppBar(
              backgroundColor: Colors.white,
              title: Text("Wanderlist", style: TextStyle(color: WanTheme.colors.pink)),
              centerTitle: true,
              actions: [_saveButton(context)],
              leading: _cancelButton(context),
              leadingWidth: 100,
            );
          } else {
            return AppBar(
              backgroundColor: Colors.white,
              title: Text("Wanderlist", style: TextStyle(color: WanTheme.colors.pink)),
              centerTitle: true,
            );
          }
          }
        return Container();
      }
    );
  }
}

class _EditWanderlistBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WanderlistCubit, WanderlistState>(
      builder: (context, state) {
        if (state is Editing) {
          return
              Container (
                padding: EdgeInsets.all(8),
              child: ListView (
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0),
                    child: _EditNameTextfield(state.wanderlist.name),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  _EditableActivityList(state.wanderlist.activities),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  //SearchField("Search Activities"),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Suggestions",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.normal)),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  ActivitySuggestions(),


                ],
              ));
        }

        return CircularProgressIndicator();
      },
      listener: (context, state) {},
    );
  }
}

class _EditNameTextfield extends StatelessWidget {
  _EditNameTextfield(this.name) {
    _controller.text = name;
  }

  final String name;
  final _controller = TextEditingController();

  _submitNewName(BuildContext context, Editing state, String text) {
    final newNameWanderlist = state.wanderlist.copyWith(name: text);
    context.read<WanderlistCubit>().madeEdit(newNameWanderlist);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WanderlistCubit, WanderlistState>(
      builder: (context, WanderlistState state) {
        if (state is Editing) {
          return TextField(
            style: TextStyle(color: Colors.black,
            fontSize: 24),
            textAlign: TextAlign.center,
            maxLines: null,
            keyboardType: TextInputType.text,
            controller: _controller,
            onSubmitted: (text) => _submitNewName(context, state, text),
          );
        }
        return Container();
      },
      listener: (context, state) {},
    );
  }
}

class _EditableActivityList extends StatelessWidget {
  _EditableActivityList(this.activities);

  final List<ActivityDetails> activities;

  _onRemoveItem(BuildContext context, Editing state, int index) {
    activities.removeAt(index);
    context.read<WanderlistCubit>().madeEdit(
          state.wanderlist.copyWith(activities: activities),
        );
  }

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return _EmptyActivityList();
    }

    return BlocConsumer<WanderlistCubit, WanderlistState>(
        builder: (context, state) {
          if (state is Editing) {
            return Container(
              padding: EdgeInsets.all(WanTheme.CARD_PADDING),
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(WanTheme.CARD_CORNER_RADIUS),
                  color: Colors.white),
              child: ReorderableListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return _EditableActivityListItem(
                    Key('$index'),
                    activities[index],
                    () => _onRemoveItem(context, state, index),
                    true,
                  );
                },
                itemCount: activities.length,
                onReorder: (int oldIndex, int newIndex) {
                  List<ActivityDetails> activities =
                      state.wanderlist.activities;
                  if (oldIndex < newIndex) {
                    newIndex--;
                  }
                  activities.insert(newIndex, activities.removeAt(oldIndex));
                  context.read<WanderlistCubit>().madeEdit(
                        state.wanderlist.copyWith(activities: activities),
                      );
                },
              ),
            );
          }

          return Text("Error!");
        },
        listener: (context, state) => {});
  }
}

class _EditableActivityListItem extends StatelessWidget {
  _EditableActivityListItem(this.key, this.activity, this.remove, this.showRemove);

  final bool showRemove;
  final Key key;
  final ActivityDetails activity;
  final Function() remove;

  @override
  Widget build(BuildContext context) {
    if (showRemove) {
      return ActivitySummaryItemSmall(
          width: MediaQuery.of(context).size.width,
          activity: activity,
          rightWidget: IconButton(icon:
          Icon(Icons.remove_circle_outline_outlined, color: Colors.grey),
            onPressed: () => remove(),
          ),
          smallIcon: true,
        );
    } else {
      return ActivitySummaryItemSmall(
        width: MediaQuery.of(context).size.width,
        activity: activity,
        smallIcon: true,
      );
    }
  }
}

class _EmptyActivityList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        "There's nothing here yet. Find some activities below!",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: "Inter"),
      ),
    );
  }
}
