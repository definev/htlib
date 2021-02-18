import 'package:flutter/material.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/src/view/book_management/book_management_screen.dart';
import 'package:htlib/styles.dart';
import 'package:styled_widget/styled_widget.dart';

class HomeBottomBar extends StatelessWidget with PreferredSizeWidget {
  final List<Widget> actions;
  final BookSortingState bookSortingState;
  final SortingMode sortingMode;
  final Function(BookSortingState state) onSort;
  final Function(SortingMode mode) onChangedMode;

  const HomeBottomBar({
    Key key,
    this.actions,
    this.bookSortingState = BookSortingState.noSort,
    this.onSort,
    this.sortingMode = SortingMode.lth,
    this.onChangedMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Durations.fastest,
      height: preferredSize.height,
      decoration: BoxDecoration(),
      child: Column(
        children: [
          Container(height: 1, color: Theme.of(context).secondaryHeaderColor),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Tooltip(
                      message: [
                        "Sắp xếp",
                        "Sắp xếp theo tên",
                        "Sắp xếp theo số lượng",
                      ][bookSortingState.index],
                      child: IconButton(
                        icon: Icon(
                          [
                            Icons.menu,
                            Icons.sort_by_alpha_rounded,
                            Icons.sort_rounded,
                          ][bookSortingState.index],
                        ),
                        onPressed: () {
                          onSort?.call(BookSortingState.values[
                              (bookSortingState.index + 1) %
                                  BookSortingState.values.length]);
                        },
                      ),
                    ),
                    HSpace(20.0),
                    if (bookSortingState != BookSortingState.noSort)
                      Tooltip(
                        message: sortingMode == SortingMode.htl
                            ? "Cao xuống thấp"
                            : "Thấp lên cao",
                        child: ElevatedButton(
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(2.0),
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.secondary),
                          ),
                          onPressed: () {
                            SortingMode newMode = SortingMode.values[
                                (sortingMode.index + 1) %
                                    SortingMode.values.length];
                            onChangedMode(newMode);
                          },
                          child: Icon(
                            sortingMode.index == 0
                                ? Icons.arrow_upward_rounded
                                : Icons.arrow_downward_rounded,
                            color: Colors.white,
                          ).padding(vertical: 4.0),
                        ),
                      ),
                  ],
                ),
                if (actions != null) Row(children: [...actions]),
              ],
            ),
          ).expanded(),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(59.0);
}
