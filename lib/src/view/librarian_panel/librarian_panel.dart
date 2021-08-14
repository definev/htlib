import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/src/view/librarian_panel/mornitor_section.dart';
import 'package:htlib/src/view/settings/components/setting_section.dart';

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
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: 250,
                    width: 250,
                    child: Image.asset(
                      'assets/images/logo.png',
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    padding: EdgeInsets.only(top: 15.0, left: 15.0),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - 59.0,
                    width: 0.5,
                    margin: EdgeInsets.only(left: 15.0),
                    color: Theme.of(context).disabledColor,
                  ),
                  Expanded(
                    child: ExpansionPanelList(
                      expansionCallback: (panelIndex, isExpanded) {
                        switch (panelIndex) {
                          case 0:
                            mornitorExpansion.value = !isExpanded;
                            break;
                          case 1:
                            settingExpansion.value = !isExpanded;
                            break;
                          default:
                        }
                      },
                      expandedHeaderPadding: EdgeInsets.zero,
                      children: [
                        ExpansionPanel(
                          headerBuilder: (context, isExpanded) {
                            return Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Icon(
                                    Icons.person,
                                    color: isExpanded ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onBackground,
                                  ),
                                ),
                                Text(
                                  'Danh sách lớp trưởng',
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                        color: isExpanded ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onBackground,
                                      ),
                                ),
                              ],
                            );
                          },
                          canTapOnHeader: true,
                          body: MornitorSection(),
                          isExpanded: mornitorExpansion.value,
                        ),
                        ExpansionPanel(
                          headerBuilder: (context, isExpanded) {
                            return Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Icon(
                                    Icons.settings,
                                    color: isExpanded ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onBackground,
                                  ),
                                ),
                                Text(
                                  'Cài đặt',
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                        color: isExpanded ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onBackground,
                                      ),
                                ),
                              ],
                            );
                          },
                          body: SettingSection(),
                          canTapOnHeader: true,
                          isExpanded: settingExpansion.value,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    }
    return Text("Hello");
  }
}
