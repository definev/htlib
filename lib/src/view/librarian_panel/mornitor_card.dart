import 'package:flutter/material.dart';
import 'package:htlib/src/model/admin_user.dart';

class MornitorCard extends StatelessWidget {
  const MornitorCard({Key? key, required this.mornitor}) : super(key: key);

  final AdminUser mornitor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: Image.network(mornitor.imageUrl!, fit: BoxFit.cover)),
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary,
              ),
              alignment: Alignment.center,
              child: Text(
                "${mornitor.className} | ${mornitor.activeMemberNumber}/${mornitor.memberNumber}",
                style: theme.textTheme.bodyText1!.copyWith(color: theme.colorScheme.onSecondary),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
