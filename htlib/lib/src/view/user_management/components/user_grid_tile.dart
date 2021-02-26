import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:htlib/_internal/utils/string_utils.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/styles.dart';
import 'package:styled_widget/styled_widget.dart';

class UserGridTile extends StatefulWidget {
  final User user;
  final Function() onTap;

  const UserGridTile(this.user, {Key key, this.onTap}) : super(key: key);

  @override
  _UserGridTileState createState() => _UserGridTileState();
}

class _UserGridTileState extends State<UserGridTile> {
  Image _avtImg;

  @override
  void initState() {
    super.initState();
    _avtImg = Image.memory(
      base64Decode(widget.user.image),
      height: double.infinity,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(borderRadius: Corners.s8Border),
        child: Column(
          children: [
            Flexible(
              flex: 2,
              child: Hero(
                tag: widget.user.image,
                child: _avtImg,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.user.name}",
                      style: Theme.of(context).textTheme.subtitle1,
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
                            text:
                                "${StringUtils.numberPhomeFormat(widget.user.phone)}",
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
                    onPressed: () {},
                    child: Text("${widget.user.currentClass}")),
              ],
            ).padding(horizontal: Insets.m, vertical: Insets.l),
          ],
        ),
      ),
    );
  }
}
