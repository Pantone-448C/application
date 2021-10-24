import 'package:application/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class AddedPointsCard extends StatefulWidget {
  AddedPointsCard({
    this.loading = true,
    this.success = false,
    this.beforePoints = 0,
    this.afterPoints = 0,
    this.activityPoints = 0,
  });

  final bool loading;
  final bool success;
  final int beforePoints;
  final int afterPoints;
  final int activityPoints;

  @override
  State<StatefulWidget> createState() => _AddedPointsCardState();
}

class _AddedPointsCardState extends State<AddedPointsCard>
    with TickerProviderStateMixin {
  _AddedPointsCardState();

  late Animation<double> _progressAnimation;
  late AnimationController _progressAnimationController;

  @override
  void initState() {
    super.initState();

    _progressAnimationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: widget.afterPoints.toDouble(),
      end: widget.afterPoints.toDouble(),
    ).animate(_progressAnimationController);
  }

  _setAnimationProgress() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 16.0, right: 16.0),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 200,
          minWidth: MediaQuery.of(context).size.width,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(WanTheme.CARD_CORNER_RADIUS)),
        child: _buildWidgetType(context),
      ),
    );
  }

  Widget _buildWidgetType(BuildContext context) {
    if (widget.loading) {
      return Center(child: CircularProgressIndicator());
    } else if (widget.success) {
      _progressAnimationController.forward();
      return TweenAnimationBuilder(
        duration: Duration(milliseconds: 500),
        tween: Tween<double>(
          begin: widget.beforePoints.toDouble(),
          end: widget.afterPoints.toDouble(),
        ),
        builder: (BuildContext context, double points, Widget? child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline_rounded, size: 32),
              Padding(padding: EdgeInsets.only(top: 16)),
              Text(
                "You've earned +" +
                    widget.activityPoints.toString() +
                    " from this activity",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: "inter",
                    fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GradientProgressIndicator(
                  value: points.toInt() / 1000,
                  gradient: WanTheme.colors.pinkOrangeGradient,
                  backgroundColor: WanTheme.colors.lightGrey,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 4)),
              Text(
                points.toStringAsFixed(0) + " points",
                style: TextStyle(
                  fontSize: 26,
                  fontFamily: "inter",
                  fontWeight: FontWeight.w600,
                  color: WanTheme.colors.pink,
                ),
              ),
            ],
          );
        },
      );
    } else if (!widget.success) {
      return Center(
        child: Text("Oops! Something went wrong. Please try again."),
      );
    } else {
      return Container();
    }
  }
}
