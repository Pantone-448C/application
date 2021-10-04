import 'package:application/apptheme.dart';
import 'package:application/components/searchfield.dart';
import 'package:application/components/wanderlist_summary_item.dart';
import 'package:application/models/wanderlist.dart';
import 'package:flutter/material.dart';

class ListOfWanderlists extends StatefulWidget {
  const ListOfWanderlists({
    Key? key,
    required this.onWanderlistTap,
    required this.wanderlists,
    this.readOnly = false,
    this.onReorder,
  }) : super(key: key);
  final void Function(Wanderlist) onWanderlistTap;
  final void Function(int, int)? onReorder;
  final readOnly;
  final List<Wanderlist> wanderlists;

  @override
  _ListOfWanderlistsState createState() => _ListOfWanderlistsState();
}

class _ListOfWanderlistsState extends State<ListOfWanderlists> {
  List<Wanderlist> matchedWanderlists = [];
  bool searching = false;

  @override
  Widget build(BuildContext context) {
    List<Wanderlist> displayedWanderlists;
    if (searching) {
      displayedWanderlists = matchedWanderlists;
    } else {
      displayedWanderlists = widget.wanderlists;
    }

    var searchBar = Padding(
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
    );

    // TODO: Factor out more arguments somehow
    if (widget.readOnly) {
      return ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: true,
        padding: EdgeInsets.all(WanTheme.CARD_PADDING),
        physics: ClampingScrollPhysics(),
        children: [
          searchBar,
          for (int index = 0; index < displayedWanderlists.length; index++)
            _TappableWanderlistCard(
              key: Key('$index'),
              wanderlist: displayedWanderlists[index],
              onWanderlistTap: widget.onWanderlistTap,
            )
        ],
      );
    } else {
      return ReorderableListView(
        header: searchBar,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: true,
        padding: EdgeInsets.all(WanTheme.CARD_PADDING),
        physics: ClampingScrollPhysics(),
        onReorder: widget.onReorder ?? (_, __) {},
        children: [
          for (int index = 0; index < displayedWanderlists.length; index++)
            _TappableWanderlistCard(
              key: Key('$index'),
              wanderlist: displayedWanderlists[index],
              onWanderlistTap: widget.onWanderlistTap,
            )
        ],
      );
    }
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
    List<Wanderlist> matches = [];
    List<String> words = query.split(" ");
    Set<int> added = Set<int>();
    for (var word in words) {
      for (var list in widget.wanderlists) {
        if (!added.contains(list)) {
          if (list.name.contains(word) || list.creatorName.contains(word)) {
            added.add(list.hashCode);
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
    required this.wanderlist,
    required this.onWanderlistTap,
  });

  final Key key;
  final Wanderlist wanderlist;
  final onWanderlistTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: WanTheme.CARD_PADDING),
      key: ValueKey(wanderlist.hashCode),
      child: InkWell(
        borderRadius: BorderRadius.all(
          Radius.circular(WanTheme.CARD_CORNER_RADIUS),
        ),
        onTap: () => onWanderlistTap(wanderlist),
        child: WanderlistSummaryItem(
          imageUrl: wanderlist.icon,
          authorName: wanderlist.creatorName,
          listName: wanderlist.name,
          numCompletedItems: 0,
          numTotalItems: wanderlist.activities.length,
        ),
      ),
    );
  }
}
