import 'package:flutter/material.dart';
import 'package:htlib/_internal/utils/string_utils.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserGridTile extends StatefulWidget {
  final User user;
  final bool selected;
  final Function() onTap;

  const UserGridTile(
    this.user, {
    Key key,
    this.onTap,
    this.selected,
  }) : super(key: key);

  @override
  _UserGridTileState createState() => _UserGridTileState();
}

class _UserGridTileState extends State<UserGridTile> {
  @override
  Widget build(BuildContext context) {
    var card = Material(
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
                  child: Image(
                    image: CachedNetworkImageProvider(widget.user.imageUrl),
                    fit: BoxFit.cover,
                    height: double.maxFinite,
                    width: double.maxFinite,
                  ),
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
                                  "${StringUtils.phoneFormat(widget.user.phone)}",
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
    if (widget.selected != null) {
      return Stack(
        children: [
          card,
          IgnorePointer(
            ignoring: !widget.selected,
            child: Opacity(
              opacity: widget.selected ? 1.0 : 0.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: Corners.s5Border,
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      onPressed: widget.onTap),
                ),
              ),
            ),
          ),
        ],
      );
    }
    return card;
  }
}
