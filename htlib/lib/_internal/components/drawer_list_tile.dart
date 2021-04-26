import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final Widget? leading;
  final Function() onTap;
  final bool selected;

  const DrawerListTile({
    Key? key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    required this.onTap,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      subtitle: subtitle,
      leading: leading,
      title: title,
      trailing: trailing,
      selectedTileColor: Colors.white12,
      selected: selected,
      onTap: onTap,
    );
  }
}
