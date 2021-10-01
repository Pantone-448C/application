import 'package:application/apptheme.dart';
import 'package:application/components/searchfield.dart';
import 'package:application/components/wanderlist_summary_item.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:flutter/material.dart';

class ListOfWanderlists extends StatefulWidget {
  const ListOfWanderlists(
      {Key? key,
      required this.onWanderlistTap,
      required this.onReorder,
      required this.readOnly,
      required this.wanderlists})
      : super(key: key);
  final void Function(UserWanderlist) onWanderlistTap;
  final onReorder;
  final readOnly;
  final List<UserWanderlist> wanderlists;

  @override
  _ListOfWanderlistsState createState() => _ListOfWanderlistsState();
}

class _ListOfWanderlistsState extends State<ListOfWanderlists> {
  List<UserWanderlist> matchedWanderlists = [];
  bool searching = false;

  @override
  Widget build(BuildContext context) {
    List<UserWanderlist> displayedWanderlists;
    if (searching) {
      displayedWanderlists = matchedWanderlists;
    } else {
      displayedWanderlists = widget.wanderlists;
    }

    return ReorderableListView(
      header: Padding(
        // search bar
        padding: EdgeInsets.symmetric(
            horizontal: WanTheme.CARD_PADDING,
            vertical: 2 * WanTheme.CARD_PADDING),
        child: TextField(
          keyboardType: TextInputType.text,
          onChanged: (value) => filterSearch(value),
          decoration: SearchField.defaultDecoration.copyWith(
            hintText: "Search Your Wanderlists",
          ),
        ),
      ),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      primary: true,
      padding: EdgeInsets.all(WanTheme.CARD_PADDING),
      physics: ClampingScrollPhysics(),
      onReorder: widget.onReorder,
      children: [
        for (int index = 0; index < displayedWanderlists.length; index++)
          _TappableWanderlistCard(
            key: Key('$index'),
            userWanderlist: displayedWanderlists[index],
            onWanderlistTap: widget.onWanderlistTap,
          )
      ],
    );
  }

  void filterSearch(String query) {
    if (query == "") {
      setState(() {
        searching = false;
      });
    } else {
      setState(() {
        searching = true;
      });
    }
    List<UserWanderlist> matches = [];
    List<String> words = query.split(" ");
    Set<int> added = Set<int>();
    for (var word in words) {
      for (var list in widget.wanderlists) {
        if (!added.contains(list.wanderlist)) {
          if (list.wanderlist.name.contains(word) ||
              list.wanderlist.creatorName.contains(word)) {
            added.add(list.wanderlist.hashCode);
            matches.add(list);
          }
        }
      }
    }
    setState(() {
      matchedWanderlists = matches;
    });
  }
}

class _TappableWanderlistCard extends StatelessWidget {
  _TappableWanderlistCard({
    required this.key,
    required this.userWanderlist,
    required this.onWanderlistTap,
  });

  final Key key;
  final UserWanderlist userWanderlist;
  final onWanderlistTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onWanderlistTap(this.userWanderlist),
      child: Container(
        margin: EdgeInsets.only(bottom: WanTheme.CARD_PADDING),
        key: ValueKey(userWanderlist.wanderlist.hashCode),
        child: WanderlistSummaryItem(
          imageUrl: userWanderlist.wanderlist.icon,
          authorName: userWanderlist.wanderlist.creatorName,
          listName: userWanderlist.wanderlist.name,
          numCompletedItems: userWanderlist.completedActivities.length,
          numTotalItems: userWanderlist.wanderlist.activities.length,
        ),
      ),
    );
  }
}
