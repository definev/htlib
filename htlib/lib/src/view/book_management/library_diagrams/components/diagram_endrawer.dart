import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:htlib/src/model/diagram_node_mode.dart';
import 'package:htlib/src/services/book_service.dart';
import 'package:htlib/src/services/state_management/diagram_node_config/diagram_node_config_cubit.dart';
import 'package:htlib/styles.dart';

class DiagramEndDrawer extends StatefulWidget {
  @override
  _DiagramEndDrawerState createState() => _DiagramEndDrawerState();
}

class _DiagramEndDrawerState extends State<DiagramEndDrawer> {
  DiagramNodeConfigCubit? _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = Get.find<DiagramNodeConfigCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiagramNodeConfigCubit, DiagramNodeConfigState>(
      bloc: _cubit,
      builder: (context, state) => state.map(
        initial: (_) => Container(),
        done: (done) => Drawer(
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppBar(
                  title: Text(done.node.label),
                  leading: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  actions: [Container()],
                ),
                Container(
                  height: 59.0,
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  margin: EdgeInsets.symmetric(vertical: Insets.m),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Loại nút",
                        style: Theme.of(context).textTheme.button,
                      ),
                      done.node.mode == DiagramNodeMode.ENTRY
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
                                  child: Icon(
                                      MaterialCommunityIcons.library_shelves),
                                ),
                              ],
                              isSelected: [
                                done.node.mode == DiagramNodeMode.LIB,
                                done.node.mode == DiagramNodeMode.SHELVES,
                              ],
                              onPressed: (value) {},
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
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.zero)),
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
        ),
      ),
    );
  }
}
