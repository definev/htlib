import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/_internal/utils/build_utils.dart';
import 'package:htlib/_internal/utils/string_utils.dart';
import 'package:htlib/src/services/book/book_service.dart';
import 'package:htlib/src/widget/book_base_list_tile.dart';
import 'package:htlib/styles.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:htlib/src/model/book_base.dart';

class BookBaseScreen extends StatelessWidget {
  final int index;
  final BookBase bookBase;
  final Function() onRemove;

  const BookBaseScreen({Key key, this.bookBase, this.index, this.onRemove})
      : super(key: key);

  Widget _bookElement(BuildContext context, String title, String value,
          {bool showDivider = true}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          Row(
            children: [
              Flexible(
                flex: 2,
                child: TextStyles.T1Text(
                  "$title",
                  color: Colors.black,
                ).center(),
              ),
              VerticalDivider(thickness: 2).constrained(height: 300 / 7),
              Flexible(
                flex: 4,
                child: TextStyles.T1Text(
                  "$value",
                  color: Colors.black,
                ).center(),
              )
            ],
          ),
          (showDivider)
              ? Container(
                  height: 2,
                  color: Theme.of(context).dividerColor,
                  margin: EdgeInsets.symmetric(horizontal: Insets.m))
              : Container(),
        ],
      ).constrained(height: (300 - 2) / 4);

  double bookDescHeight(BuildContext context) {
    if (MediaQuery.of(context).size.height < 730) return (300 - 2) / 4 * 2;
    if (MediaQuery.of(context).size.height < 850) return (300 - 2) / 4 * 3;
    return 300;
  }

  Widget bookDesc(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedDefaultTextStyle(
            style: TextStyles.H1
                .copyWith(color: Theme.of(context).colorScheme.secondary),
            duration: Durations.fast,
            child: Text(
              "${bookBase.name}",
              textAlign: TextAlign.center,
              maxLines: BuildUtils.specifyForMobile(context,
                  defaultValue: 1, mobile: 2),
              overflow: TextOverflow.ellipsis,
            )
                .constrained(
                  maxWidth: BuildUtils.specifyForMobile(
                    context,
                    defaultValue: PageBreak.defaultPB.tablet,
                    mobile: MediaQuery.of(context).size.width,
                  ),
                )
                .padding(horizontal: Insets.sm),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(.1),
                  blurRadius: 30,
                ),
              ],
              border:
                  Border.all(color: Theme.of(context).dividerColor, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.symmetric(
                vertical: Insets.l, horizontal: Insets.mid),
            height: bookDescHeight(context),
            width: BuildUtils.specifyForMobile(
              context,
              defaultValue: PageBreak.defaultPB.tablet,
              mobile: MediaQuery.of(context).size.width,
            ),
            child: Scrollbar(
              thickness: 8,
              radius: Radius.circular(10),
              showTrackOnHover: true,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _bookElement(context, "Mã ISBN", "${bookBase.isbn}"),
                  _bookElement(context, "Giá tiền",
                      "${StringUtils.moneyFormat(bookBase.price)}"),
                  _bookElement(context, "Số lượng", "${bookBase.quantity}"),
                  _bookElement(
                      context, "Nhà xuất bản", "${bookBase.publisher}"),
                  _bookElement(context, "Năm xuất bản", "${bookBase.year}"),
                  _bookElement(context, "Thể loại", "${bookBase.type}",
                      showDivider: false),
                ],
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              Navigator.pop(context);

              Future.delayed(
                Durations.medium,
                () {
                  GetIt.instance<BookService>().remove(bookBase);
                  Future.delayed(
                    Durations.fastest,
                    () => AnimatedList.of(context).removeItem(
                      index,
                      (context, animation) => SliverIgnorePointer(
                        ignoring: true,
                        sliver: BookBaseListTile(bookBase),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          bookDesc(context).padding(
            vertical: BuildUtils.getResponsive(
              context,
              desktop: Insets.xl,
              tablet: Insets.l,
              mobile: Insets.m,
              tabletPortrait: Insets.mid,
            ),
          ),
          Container(
            height: 1.5,
            color: Theme.of(context).dividerColor,
            constraints: BoxConstraints(maxWidth: PageBreak.defaultPB.tablet),
          ),
          Theme(
            data: Theme.of(context).copyWith(
              accentColor: Colors.transparent,
              focusColor: Colors.black12,
              highlightColor: Colors.grey.withOpacity(0.1),
              tabBarTheme: Theme.of(context).tabBarTheme.copyWith(
                    unselectedLabelColor: Colors.grey,
                    indicator: UnderlineTabIndicator(
                      insets: EdgeInsets.zero,
                      borderSide: BorderSide(
                          width: 2.0, color: Theme.of(context).primaryColor),
                    ),
                    labelColor: Theme.of(context).primaryColor,
                    labelStyle: TextStyles.T1,
                    unselectedLabelStyle: TextStyles.T1,
                  ),
            ),
            child: DefaultTabController(
              initialIndex: 0,
              length: 2,
              child: Column(
                children: [
                  Builder(
                    builder: (context) {
                      return TabBar(
                        tabs: [
                          Tab(
                            icon: Icon(Feather.users),
                            text: "Người đang mượn sách",
                            iconMargin: EdgeInsets.only(bottom: Insets.sm),
                          ),
                          Tab(
                            icon: Icon(Feather.file_text),
                            text: "Lịch sử cho mượn",
                            iconMargin: EdgeInsets.only(bottom: Insets.sm),
                          ),
                        ],
                        onTap: (value) {},
                      );
                    },
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Center(child: Text("SCREEN 1")),
                        Center(child: Text("SCREEN 1")),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ).constrained(maxWidth: PageBreak.defaultPB.tablet).expanded(),
        ],
      ).center(),
    );
  }
}
