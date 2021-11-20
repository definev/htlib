import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:htlib/_internal/utils/launcher_utils.dart';
import 'package:htlib/_internal/utils/string_utils.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/src/view/user_management/components/user_screen.dart';

enum UserListTileMode { short, long, call }

class UserListTile extends StatelessWidget {
  final User user;
  final Function()? onTap;
  final UserListTileMode mode;

  const UserListTile(this.user, {Key? key, this.onTap, this.mode = UserListTileMode.long}) : super(key: key);

  Widget? modeWidget(BuildContext context, UserListTileMode mode) {
    switch (mode) {
      case UserListTileMode.long:
        return SizedBox(
          height: 40,
          width: 85,
          child: ElevatedButton(
            onPressed: () => onTap?.call(),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      "${user.className}",
                      style: Theme.of(context).textTheme.button!.copyWith(
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
      case UserListTileMode.short:
        return null;
      case UserListTileMode.call:
        return SizedBox(
          height: 40,
          width: 75,
          child: ElevatedButton(
            onPressed: () => LauncherUtils.call(user.phone),
            child: Icon(Icons.call),
          ),
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedShape: RoundedRectangleBorder(),
      closedColor: Theme.of(context).backgroundColor,
      openColor: Theme.of(context).backgroundColor,
      closedElevation: 0.5,
      openElevation: 1.0,
      openBuilder: (context, _) => UserScreen(user),
      closedBuilder: (context, _) => ListTile(
        onTap: () {
          if (onTap == null) _.call();
          onTap?.call();
        },
        isThreeLine: true,
        dense: true,
        leading: Icon(Feather.user),
        title: Text(user.name),
        subtitle: Text(StringUtils.phoneFormat(user.phone)),
        trailing: modeWidget(context, mode),
      ),
    );
  }
}
