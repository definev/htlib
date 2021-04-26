import 'package:flutter/material.dart';

class GroupListTile extends StatelessWidget {
  final Widget title;
  final Widget? leading;
  final Widget? trailing;
  final bool border;
  final bool isExpanded;
  final Function(bool) onChanged;
  final List<Widget> children;

  const GroupListTile({
    Key? key,
    required this.isExpanded,
    required this.onChanged,
    required this.title,
    this.leading,
    this.trailing,
    this.border = false,
    this.children = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: isExpanded
          ? const EdgeInsets.fromLTRB(0, 10, 0, 10)
          : const EdgeInsets.all(0),
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            width: border ? 1 : 0,
            color: Colors.white10,
          ),
        ),
      ),
      child: ExpansionTile(
        title: title,
        leading: leading,
        trailing: trailing,
        children: children,
        tilePadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
        backgroundColor: Colors.white12,
        onExpansionChanged: (expanded) {
          onChanged(expanded);
        },
      ),
    );
  }
}
