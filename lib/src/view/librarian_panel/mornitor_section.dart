import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/src/controllers/librarian_controller.dart';
import 'package:htlib/src/model/admin_user.dart';
import 'package:htlib/src/utils/class_utils.dart';
import 'package:htlib/src/view/librarian_panel/add_mornitor_dialog.dart';
import 'package:htlib/src/view/librarian_panel/mornitor_card.dart';
import 'package:htlib/styles.dart';
import 'package:ink_page_indicator/ink_page_indicator.dart';

class MornitorSection extends HookWidget {
  const MornitorSection({Key? key}) : super(key: key);

  Widget _bigLayout(
    BuildContext context, {
    required List<List<AdminUser?>> data,
  }) {
    

    return Row(
      children: [
        ...List.generate(data.length, (index) {
          final classList = data[index];
          int year = ClassUtils.getYearOfBirthFromIndex(index);
          int k = ClassUtils.yearOfBirthToK(year);

          return Flexible(
            child: Column(
              children: [
                Container(
                  height: 59,
                  color: Theme.of(context).primaryColor,
                  alignment: Alignment.center,
                  child: Text(
                    'Khóa K${k}',
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
                        classList.length,
                        (index) {
                          if (classList[index] == null) {
                            return DottedBorder(
                              color: Theme.of(context).colorScheme.onBackground,
                              borderType: BorderType.RRect,
                              strokeCap: StrokeCap.square,
                              radius: Radius.circular(Corners.s5),
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
                                          k: k,
                                          classNumber: index + 1,
                                        ),
                                      );
                                    },
                                  ),
                                  Center(child: Text('K${k}-A${index + 1}')),
                                ],
                              ),
                            );
                          } else {
                            return MornitorCard(mornitor: classList[index]!);
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
    );
  }

  Widget _smallLayout(
    BuildContext context, {
    required PageIndicatorController controller,
    required List<List<AdminUser?>> data,
  }) =>
      Stack(
        children: [
          PageView.builder(
            controller: controller,
            itemCount: data.length,
            itemBuilder: (context, index) {
              final classList = data[index];
              int year = ClassUtils.getYearOfBirthFromIndex(index);
              int k = ClassUtils.yearOfBirthToK(year);

              return Column(
                children: [
                  Container(
                    height: 59,
                    color: Theme.of(context).primaryColor,
                    alignment: Alignment.center,
                    child: Text(
                      'Khóa K$k',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                    ),
                  ),
                  Expanded(
                    child: GridView.extent(
                      maxCrossAxisExtent: 200,
                      mainAxisSpacing: Insets.m,
                      crossAxisSpacing: Insets.m,
                      padding: EdgeInsets.all(Insets.m),
                      children: [
                        ...List.generate(
                          classList.length,
                          (index) {
                            if (classList[index] == null) {
                              return DottedBorder(
                                color: Theme.of(context).colorScheme.onBackground,
                                borderType: BorderType.RRect,
                                strokeCap: StrokeCap.square,
                                radius: Radius.circular(Corners.s5),
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
                                            k: k,
                                            classNumber: index + 1,
                                          ),
                                        );
                                      },
                                    ),
                                    Center(child: Text('K${k}-A${index + 1}')),
                                  ],
                                ),
                              );
                            } else {
                              return MornitorCard(mornitor: classList[index]!);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkPageIndicator(
              gap: 10,
              padding: 15,
              shape: IndicatorShape.circle(Insets.sm),
              inactiveColor: Theme.of(context).disabledColor,
              activeColor: Theme.of(context).primaryColor,
              inkColor: Theme.of(context).primaryColorDark,
              controller: controller,
              pageCount: data.length,
              style: InkStyle.normal,
            ),
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    final controller = useProvider(librarianControllerProvider);
    final pageController = useMemoized(() => PageIndicatorController());

    return SizedBox(
      height: 500.0,
      child: controller.map(
        data: (value) {
          final data = value.value;

          return Scaffold(
            body: PageBreak.defaultPB.isMobile(context)
                ? _smallLayout(context, data: data, controller: pageController)
                : _bigLayout(context, data: data),
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
