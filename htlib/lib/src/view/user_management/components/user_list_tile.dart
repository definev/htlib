import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:htlib/_internal/utils/string_utils.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/styles.dart';

class UserListTile extends StatelessWidget {
  final User user;
  final Function() onTap;
  final bool isSmall;

  const UserListTile(this.user, {Key key, this.onTap, this.isSmall = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).tileColor,
      onTap: onTap,
      isThreeLine: true,
      dense: true,
      leading: Icon(Feather.user),
      title: Text(user.name),
      subtitle: Text(StringUtils.phoneFormat(user.phone)),
      trailing: Container(
        decoration: BoxDecoration(
          borderRadius: Corners.s5Border,
          color: Theme.of(context).primaryColor,
        ),
        height: 40,
        width: isSmall ? 60 : 100,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: Insets.sm),
        child: Row(
          children: [
            if (!isSmall)
              Text(
                "Lớp:",
                style: Theme.of(context).textTheme.button.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            Expanded(
              child: Center(
                child: Text(
                  user.currentClass,
                  style: Theme.of(context).textTheme.button.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
