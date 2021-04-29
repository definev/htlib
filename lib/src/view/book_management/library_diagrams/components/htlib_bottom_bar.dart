import 'package:flutter/material.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/styles.dart';
import 'package:provider/provider.dart';
import 'package:htlib/src/services/state_management/diagram_notifier/diagram_bottom_bar_notifier.dart';

class HtlibBottomBar extends StatefulWidget {
  const HtlibBottomBar({Key? key}) : super(key: key);

  @override
  _HtlibBottomBarState createState() => _HtlibBottomBarState();
}

class _HtlibBottomBarState extends State<HtlibBottomBar> {
  Color? get bgColor => Color.lerp(
      Theme.of(context).colorScheme.background,
      Theme.of(context).colorScheme.brightness == Brightness.dark
          ? Colors.white
          : Theme.of(context).primaryColor,
      0.05);

  Color? get dragColor => Color.lerp(
      Theme.of(context).colorScheme.background,
      Theme.of(context).colorScheme.brightness == Brightness.dark
          ? Colors.white
          : Theme.of(context).primaryColor,
      0.1);
  late DiagramBottomBarNotifier _notifier;
  bool isInit = false;

  Widget tile(Book book) {
    return Container(
      height: double.infinity,
      width: 250.0,
      color: bgColor,
      padding: EdgeInsets.all(Insets.m),
      child: Center(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    book.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Số lượng: ${book.quantity}",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Draggable<String>(
                  data: book.id,
                  dragAnchor: DragAnchor.pointer,
                  feedback: Container(
                    height: 250.0,
                    width: 250.0,
                    color: dragColor,
                    padding: EdgeInsets.all(Insets.m),
                    child: Center(
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  book.name,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    margin: EdgeInsets.only(right: Insets.m),
                  ),
                  child: SizedBox(
                    height: 45.0,
                    width: 45.0,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero)),
                      child: Icon(Icons.drag_handle),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      margin: EdgeInsets.only(right: Insets.m),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isInit == false) {
      _notifier = context.read();
      _notifier.addListener(() => setState(() {}));
      isInit = true;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: _notifier.expand ? 300 : 56,
      width: double.infinity,
      color: bgColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: Insets.m, vertical: 21 / 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Danh sách sách chưa phân loại",
                    style: Theme.of(context).textTheme.subtitle1),
                SizedBox(
                  height: 35,
                  width: 35,
                  child: ElevatedButton(
                    onPressed: () {
                      _notifier.setExpand(!_notifier.expand);
                      setState(() {});
                    },
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero)),
                    child: Icon(
                        _notifier.expand
                            ? Icons.expand_more_outlined
                            : Icons.expand_less_outlined,
                        size: 20),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Color.lerp(
                  Theme.of(context).colorScheme.background,
                  Theme.of(context).colorScheme.brightness == Brightness.dark
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                  0.1),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _notifier.bookList.length,
                itemBuilder: (context, index) =>
                    tile(_notifier.bookList[index]),
                padding: EdgeInsets.only(
                  top: Insets.m,
                  bottom: Insets.m,
                  left: Insets.m,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
