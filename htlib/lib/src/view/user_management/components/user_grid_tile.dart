import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:htlib/_internal/utils/string_utils.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/styles.dart';

class UserGridTile extends StatefulWidget {
  final User user;
  final Uint8List image;
  final Function() onTap;

  const UserGridTile(this.user, {Key key, this.onTap, this.image})
      : super(key: key);

  @override
  _UserGridTileState createState() => _UserGridTileState();
}

class _UserGridTileState extends State<UserGridTile> {
  Image _avtImg;

  @override
  void initState() {
    super.initState();
    _avtImg = Image.memory(
          widget.image,
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        ) ??
        Image.memory(
          base64Decode(widget.user.image),
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).tileColor,
      borderRadius: Corners.s5Border,
      elevation: 1.5,
      child: InkWell(
        borderRadius: Corners.s5Border,
        onTap: widget.onTap,
        child: Column(
          children: [
            Flexible(
              flex: 2,
              child: Hero(
                tag: widget.user.phone,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Corners.s5Radius),
                  child: _avtImg,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Insets.m, vertical: Insets.l),
              child: Row(
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
                    onPressed: widget.onTap,
                    child: Text("${widget.user.currentClass}"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
