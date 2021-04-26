import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/components/drawer_group_tile.dart';
import 'package:htlib/_internal/components/drawer_list_tile.dart';
import 'package:htlib/src/services/book_service.dart';
import 'package:htlib/src/services/state_management/diagram_node_config/diagram_node_config_cubit.dart';

class DiagramEndDrawer extends StatefulWidget {
  @override
  _DiagramEndDrawerState createState() => _DiagramEndDrawerState();
}

class _DiagramEndDrawerState extends State<DiagramEndDrawer> {
  DiagramNodeConfigCubit? _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = Get.find();
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
                DrawerListTile(
                  title: Text("Thể loại"),
                  trailing: Text("${done.node.mode}"),
                  onTap: () {},
                ),
                GroupListTile(
                  title: Text("Sách trên kệ"),
                  isExpanded: true,
                  onChanged: (open) {},
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
