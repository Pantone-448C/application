import 'package:application/apptheme.dart';
import 'package:application/components/activity_summary_item_small.dart';
import 'package:application/models/activity.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:application/repositories/wanderlist/wanderlist_repository.dart';
import 'package:application/wanderlist/cubit/wanderlist_cubit.dart';
import 'package:application/wanderlist/cubit/wanderlist_state.dart';
import 'package:application/wanderlist/widgets/add_activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditWanderlistPage extends StatelessWidget {
  EditWanderlistPage(this.userWanderlist);

  final UserWanderlist userWanderlist;

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
    return IconButton(

      icon: Icon(Icons.close_rounded,
        color: Theme.of(context).accentColor),
      onPressed: () {
        context.read<WanderlistCubit>().cancelEdit();
      },
    );
  }

  Widget _saveButton(BuildContext context) {
    return
      ElevatedButton (
        onPressed: () {
          context.read<WanderlistCubit>().endEdit();
        },
        child: Text("Save")
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WanderlistCubit, WanderlistState>(
      builder: (context, state) {
        return Container(
          child: SafeArea(
            child: AppBar(
              backgroundColor: Colors.white12,
              foregroundColor: Colors.black,
              elevation: 0,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: _saveButton(context),
                )
              ],
              leading: _cancelButton(context),
              title: Text("Editing Wanderlist",
                  style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.normal,
                      fontFamily: "Inter")),
            ),
          ),
        );
      },
      listener: (context, state) => {},
    );
  }
}

class _EditWanderlistBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WanderlistCubit, WanderlistState>(
      builder: (context, state) {
        if (state is Editing) {
          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 48.0, right: 48.0),
                    child: _EditNameTextfield(state.wanderlist.wanderlist.name),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  _EditableActivityList(state.wanderlist.wanderlist.activities),
                  Padding(padding: EdgeInsets.only(top: 10)),
                ],
              ),
              AddActivityOverlay(),
            ],
          );
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
    final newNameWanderlist = state.wanderlist.copyWith(
      wanderlist: state.wanderlist.wanderlist.copyWith(
        name: text,
      ),
    );
    context.read<WanderlistCubit>().madeEdit(newNameWanderlist);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WanderlistCubit, WanderlistState>(
      builder: (context, WanderlistState state) {
        if (state is Editing) {
          return TextField(
            textAlign: TextAlign.center,
            controller: _controller,
            onTap: () => _controller.selection = TextSelection(
              baseOffset: 0,
              extentOffset: _controller.value.text.length,
            ),
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
          state.wanderlist.copyWith(
            wanderlist:
                state.wanderlist.wanderlist.copyWith(activities: activities),
          ),
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
              width: MediaQuery.of(context).size.width * 0.95,
              padding: EdgeInsets.all(WanTheme.CARD_PADDING),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(WanTheme.CARD_CORNER_RADIUS),
                  color: Colors.white),
              child: ReorderableListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return _EditableActivityListItem(
                    Key('$index'),
                    activities[index],
                    () => _onRemoveItem(context, state, index),
                  );
                },
                itemCount: activities.length,
                onReorder: (int oldIndex, int newIndex) {
                  List<ActivityDetails> activities =
                      state.wanderlist.wanderlist.activities;
                  if (oldIndex < newIndex) {
                    newIndex--;
                  }
                  activities.insert(newIndex, activities.removeAt(oldIndex));
                  context.read<WanderlistCubit>().madeEdit(
                        state.wanderlist.copyWith(
                          wanderlist: state.wanderlist.wanderlist
                              .copyWith(activities: activities),
                        ),
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
  _EditableActivityListItem(this.key, this.activity, this.remove);

  final Key key;
  final ActivityDetails activity;
  final Function() remove;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          IconButton(
            icon:
                Icon(Icons.remove_circle_outline_outlined, color: Colors.grey),
            onPressed: () {
              remove();
            },
          ),
          ActivitySummaryItemSmall(
            width: MediaQuery.of(context).size.width * 0.75,
            activity: activity,
            rightWidget: Icon(Icons.drag_handle, color: Colors.grey),
            smallIcon: true,
          ),
        ],
      ),
    );
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
