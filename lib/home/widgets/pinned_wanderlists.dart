import 'package:application/apptheme.dart';
import 'package:application/components/wanderlist_summary_item.dart';
import 'package:application/models/wanderlist.dart';
import 'package:flutter/material.dart';

class PinnedWanderlists extends StatelessWidget {
  const PinnedWanderlists(this.pinnedWanderlists, this.gotoWanderlistsPage);

  final List<Wanderlist> pinnedWanderlists;
  final Function() gotoWanderlistsPage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PinnedWanderlistsContent(pinnedWanderlists),
        _ViewAllWanderlistsButton(gotoWanderlistsPage),
      ],
    );
  }
}

class _PinnedWanderlistsContent extends StatelessWidget {
  const _PinnedWanderlistsContent(this.pinnedWanderlists);

  final List<Wanderlist> pinnedWanderlists;

  static const String title = "Pinned Wanderlists";
  static const Radius corner = Radius.circular(WanTheme.CARD_CORNER_RADIUS);

  Widget _contentTitle(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 14.0),
      child: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Container(),
            ),
            TextSpan(
              text: title,
              style: Theme.of(context).textTheme.headline3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _wanderlists(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        Wanderlist pinnedWanderlist = pinnedWanderlists[index];
        return WanderlistSummaryItem(
          listName: pinnedWanderlist.name,
          authorName: pinnedWanderlist.creatorName,
          numTotalItems: pinnedWanderlist.activityReferences.length,
          imageUrl: pinnedWanderlist.icon,
        );
      },
      itemCount: pinnedWanderlists.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: WanTheme.colors.white,
        borderRadius: BorderRadius.only(
          topLeft: corner,
          topRight: corner,
        ),
      ),
      padding: EdgeInsets.all(10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_contentTitle(context), _wanderlists(context)]),
    );
  }
}

class _ViewAllWanderlistsButton extends StatelessWidget {
  _ViewAllWanderlistsButton(this.gotoWanderlistsPage);

  final Function() gotoWanderlistsPage;

  static const Radius corner = Radius.circular(WanTheme.CARD_CORNER_RADIUS);

  Widget _background(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: corner,
              bottomRight: corner,
            ),
            color: WanTheme.colors.white,
          ),
        ),
        Container(
          height: 25,
        ),
      ],
    );
  }

  Widget _button(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(WanTheme.BUTTON_CORNER_RADIUS),
              ),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "View all Wanderlists",
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(color: WanTheme.colors.white),
          ),
        ),
        onPressed: () => gotoWanderlistsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _background(context),
        _button(context),
      ],
    );
  }
}
