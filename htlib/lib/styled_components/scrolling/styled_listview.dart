import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/app_extensions.dart';
import 'package:htlib/styled_components/scrolling/styled_scrollbar.dart';
import 'package:htlib/styled_components/styled_card.dart';
import 'package:htlib/styled_components/styled_custom_icon.dart';
import 'package:htlib/styles.dart';
import 'package:htlib/themes.dart';
import 'package:flutter/material.dart';

typedef IndexedWidgetBuilder(BuildContext context, int index);

class StyledScrollPhysics extends AlwaysScrollableScrollPhysics {}

/// Core ListView for the app.
/// Wraps a [ScrollbarListStack] + [ListView.builder] and assigns the 'Styled' scroll physics for the app
/// Exposes a controller so other widgets can manipulate the list
class StyledListView extends StatefulWidget {
  final double itemExtent;
  final int itemCount;
  final Axis axis;
  final EdgeInsets padding;
  final EdgeInsets scrollbarPadding;
  final double barSize;

  final IndexedWidgetBuilder itemBuilder;

  StyledListView({
    Key key,
    @required this.itemBuilder,
    @required this.itemCount,
    this.itemExtent,
    this.axis = Axis.vertical,
    this.padding,
    this.barSize,
    this.scrollbarPadding,
  }) : super(key: key) {
    assert(itemExtent != 0, "Item extent should never be 0, null is ok.");
  }

  @override
  StyledListViewState createState() => StyledListViewState();
}

/// State is public so this can easily be controlled externally
class StyledListViewState extends State<StyledListView> {
  ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(StyledListView oldWidget) {
    if (oldWidget.itemCount != widget.itemCount ||
        oldWidget.itemExtent != widget.itemExtent) {
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    double contentSize =
        (widget.itemCount ?? 0.0) * (widget.itemExtent ?? 00.0);
    Widget listContent = ScrollbarListStack(
      contentSize: contentSize,
      axis: widget.axis,
      controller: scrollController,
      barSize: widget.barSize ?? 12,
      scrollbarPadding: widget.scrollbarPadding,
      child: ListView.builder(
        padding: widget.padding,
        scrollDirection: widget.axis,
        physics: StyledScrollPhysics(),
        controller: scrollController,
        itemExtent: widget.itemExtent,
        itemCount: widget.itemCount,
        itemBuilder: (c, i) => widget.itemBuilder(c, i),
      ),
    );
    return listContent;
  }
}

class StyledListViewWithTitle extends StatelessWidget {
  final Color bgColor;
  final String title;
  final IconData icon;
  final List<Widget> listItems;

  const StyledListViewWithTitle(
      {Key key, this.bgColor, this.title, this.listItems, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Get.find<Rx<AppTheme>>().value;
    return StyledCard(
      bgColor: bgColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...{
                StyledCustomIcon(icon, color: theme.accent1Darker),
                HSpace(Insets.sm),
              },
              Text(title, style: TextStyles.T2.textColor(theme.accent1Darker)),
            ],
          ),
          VSpace(Insets.sm),
          StyledListView(
              itemCount: listItems.length,
              itemBuilder: (_, i) => listItems[i]).flexible()
        ],
      ).padding(left: Insets.l * .75, right: Insets.m, vertical: Insets.m),
    );
  }
}
