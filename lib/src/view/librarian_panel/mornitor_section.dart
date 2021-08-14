import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:htlib/src/controllers/librarian_controller.dart';
import 'package:htlib/src/view/librarian_panel/add_mornitor_dialog.dart';
import 'package:htlib/styles.dart';

class MornitorSection extends HookWidget {
  const MornitorSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = useProvider(librarianControllerProvider);

    return SizedBox(
      height: 500.0,
      child: controller.map(
        data: (value) {
          final data = value.value;

          return Scaffold(
            body: Row(
              children: [
                ...List.generate(data.length, (index) {
                  final grades = data[index];
                  int gradeNumber = 10 + index;

                  return Flexible(
                    child: Column(
                      children: [
                        Container(
                          height: 59,
                          color: Theme.of(context).primaryColor,
                          alignment: Alignment.center,
                          child: Text(
                            'Khối $gradeNumber',
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                          ),
                        ),
                        Expanded(
                          child: GridView.extent(
                            maxCrossAxisExtent: 200,
                            mainAxisSpacing: Insets.sm,
                            crossAxisSpacing: Insets.sm,
                            padding: EdgeInsets.symmetric(
                              vertical: Insets.sm,
                              horizontal: Insets.sm / 2,
                            ),
                            children: [
                              ...List.generate(
                                grades.length,
                                (index) {
                                  if (grades[index] == null) {
                                    return DottedBorder(
                                      color: Theme.of(context).colorScheme.onBackground,
                                      borderType: BorderType.RRect,
                                      strokeCap: StrokeCap.square,
                                      radius: Radius.circular(8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.add),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) => AddMonitorDialog(
                                                  grade: gradeNumber,
                                                  classNumber: index + 1,
                                                ),
                                              );
                                            },
                                          ),
                                          Center(child: Text('Lớp ${gradeNumber}A${index + 1}')),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Card(child: Text(grades[index]!.name));
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        },
        loading: (_) => Center(child: CircularProgressIndicator()),
        error: (e) => Center(
          child: Text(e.toString()),
        ),
      ),
    );
  }
}
