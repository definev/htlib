import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:htlib/_internal/utils/string_utils.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/styles.dart';
import 'package:styled_widget/styled_widget.dart';

class UserGridTile extends StatelessWidget {
  final User user;
  final Function() onTap;

  const UserGridTile(this.user, {Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: Corners.s8Border),
      child: Column(
        children: [
          Flexible(
            flex: 2,
            child: Image.memory(
              base64Decode(user.image),
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${user.name}",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  RichText(
                    text: TextSpan(
                      text: "SDT: ",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: "${StringUtils.numberPhomeFormat(user.phone)}",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2
                              .copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              OutlinedButton(
                  onPressed: () {}, child: Text("${user.currentClass}")),
            ],
          ).padding(horizontal: Insets.m, vertical: Insets.l),
        ],
      ),
    );
  }
}
