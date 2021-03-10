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
      trailing: SizedBox(
        height: 40,
        width: isSmall ? 60 : 75,
        child: ElevatedButton(
          onPressed: onTap,
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    "${user.currentClass}",
                    style: Theme.of(context).textTheme.button.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: isSmall ? FontSizes.s11 : null,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
