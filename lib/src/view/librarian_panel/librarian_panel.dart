import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/src/view/librarian_panel/mornitor_section.dart';
import 'package:htlib/src/view/settings/components/setting_section.dart';
import 'package:htlib/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multiavatar/multiavatar.dart';

class LibrarianPanel extends HookWidget {
  const LibrarianPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mornitorExpansion = useState(false);
    final settingExpansion = useState(false);

    if (PageBreak.defaultPB.isDesktop(context)) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          VSpace(59.0),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: 250,
                  width: 250,
                  child: SvgPicture.string(multiavatar('cvufn230fh2finsaifn[0aesrf1c14-12v nb4p2qnvu49q23[0t8rvhnq30THQ30HR0I')),
                  // child: Image.asset(
                  //   'assets/images/logo.png',
                  //   color: Theme.of(context).colorScheme.primary,
                  // ),
                  padding: EdgeInsets.only(top: 15.0, left: 15.0),
                ),
                Container(
                  height: MediaQuery.of(context).size.height - 59.0,
                  width: 0.5,
                  margin: EdgeInsets.only(left: 15.0),
                  color: Theme.of(context).disabledColor,
                ),
                Expanded(
                  child: ListView(
                    children: [
                      ExpansionTile(
                        tilePadding: EdgeInsets.only(
                          top: Insets.m,
                          bottom: Insets.m,
                          left: 0.0,
                          right: 15.0,
                        ),
                        childrenPadding: EdgeInsets.only(bottom: 10),
                        title: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Icon(
                                Icons.person,
                                color: mornitorExpansion.value ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                            Text(
                              'Danh sách lớp trưởng',
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: mornitorExpansion.value ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.onBackground,
                                  ),
                            ),
                          ],
                        ),
                        children: [MornitorSection()],
                        onExpansionChanged: (value) => mornitorExpansion.value = value,
                        initiallyExpanded: mornitorExpansion.value,
                      ),
                      ExpansionTile(
                        tilePadding: EdgeInsets.only(
                          top: Insets.m,
                          bottom: Insets.m,
                          left: 0.0,
                          right: 15.0,
                        ),
                        title: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Icon(
                                Icons.settings,
                                color: settingExpansion.value ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                            Text(
                              'Cài đặt',
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: settingExpansion.value ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.onBackground,
                                  ),
                            ),
                          ],
                        ),
                        children: [SettingSection()],
                        onExpansionChanged: (value) => settingExpansion.value = value,
                        initiallyExpanded: settingExpansion.value,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    return Text("Hello");
  }
}
