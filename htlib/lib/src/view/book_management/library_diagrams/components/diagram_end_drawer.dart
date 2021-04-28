import 'package:flutter/material.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/src/services/state_management/diagram_node_notifier/diagram_node_notifier.dart';
import 'package:htlib/src/view/book_management/library_diagrams/model/library_config.dart';
import 'package:provider/provider.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:htlib/src/model/diagram_node_mode.dart';
import 'package:htlib/src/services/book_service.dart';
import 'package:htlib/styles.dart';

class DiagramEndDrawer extends StatefulWidget {
  @override
  _DiagramEndDrawerState createState() => _DiagramEndDrawerState();
}

class _DiagramEndDrawerState extends State<DiagramEndDrawer> {
  late DiagramEndDrawerNotifier notifier;
  bool isInit = false;
  TextEditingController _controller = TextEditingController();

  LibraryConfig get config => context.read();

  @override
  Widget build(BuildContext context) {
    notifier = context.read<DiagramEndDrawerNotifier>();

    if (notifier.state == DiagramEndDrawerNotifierState.SETTINGS) {
      return Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppBar(
                title: Text("Cài đặt"),
                leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [Container()],
              ),
              ExpansionTile(
                title: Text("Cài đặt node"),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: Insets.mid),
                        child: Text(
                          "Chiều dọc",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      SizedBox(
                        width: 180.0,
                        child: Slider(
                          min: 250.0,
                          max: 600.0,
                          value: config.height,
                          onChanged: (double value) {
                            config.changeHeight(value);
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: Insets.mid),
                        child: Text(
                          "Chiều ngang",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      SizedBox(
                        width: 180.0,
                        child: Slider(
                          min: 250.0,
                          max: 600.0,
                          value: config.width,
                          onChanged: (double value) {
                            config.changeWidth(value);
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: Insets.mid),
                        child: Text(
                          "Nút thêm",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      SizedBox(
                        width: 180.0,
                        child: Slider(
                          min: 50.0,
                          max: 200.0,
                          value: config.size,
                          onChanged: (double value) {
                            if (config.height > value * 2 &&
                                config.width > value * 2) {
                              config.changeSize(value);
                              setState(() {});
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              title: Text(notifier.node!.label.isBlank == true
                  ? "Chưa Đặt Tên"
                  : notifier.node!.label),
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [Container()],
            ),
            VSpace(Insets.sm),
            Container(
              height: 59.0,
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tên nút",
                    style: Theme.of(context).textTheme.button,
                  ),
                  SizedBox(
                    width: 160,
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Sửa tên nút",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.check),
                          onPressed: () {
                            notifier.changeLabel(_controller.text);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 59.0,
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              margin: EdgeInsets.symmetric(vertical: Insets.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Loại nút",
                    style: Theme.of(context).textTheme.button,
                  ),
                  notifier.node!.mode == DiagramNodeMode.ENTRY
                      ? ToggleButtons(
                          children: [
                            Tooltip(
                              message: "Điểm khởi đầu",
                              child: Icon(Icons.home_filled),
                            ),
                          ],
                          isSelected: [true],
                          onPressed: (value) {},
                        )
                      : ToggleButtons(
                          children: [
                            Tooltip(
                              message: "Phòng đọc",
                              child: Icon(MaterialCommunityIcons.library),
                            ),
                            Tooltip(
                              message: "Phòng mượn sách",
                              child:
                                  Icon(MaterialCommunityIcons.library_shelves),
                            ),
                          ],
                          isSelected: [
                            notifier.node!.mode == DiagramNodeMode.LIB,
                            notifier.node!.mode == DiagramNodeMode.SHELVES,
                          ],
                          onPressed: (value) {
                            if (value == 0)
                              notifier.changeMode(DiagramNodeMode.LIB);
                            if (value == 1)
                              notifier.changeMode(DiagramNodeMode.SHELVES);
                            setState(() {});
                          },
                        ),
                ],
              ),
            ),
            ExpansionTile(
              title: Text("Sách trên kệ"),
              children: Get.find<BookService>()
                  .bookListCubit
                  .list
                  .map((e) => ListTile(
                        title: Text(
                          e.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                        leading: Icon(Icons.book),
                        subtitle: Text("Số lượng: ${e.quantity}"),
                        trailing: SizedBox(
                          height: 30,
                          width: 30,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                padding:
                                    MaterialStateProperty.all(EdgeInsets.zero)),
                            child: Icon(
                              Icons.arrow_forward_outlined,
                              size: 13,
                            ),
                            onPressed: () {},
                          ),
                        ),
                        onTap: () {},
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
