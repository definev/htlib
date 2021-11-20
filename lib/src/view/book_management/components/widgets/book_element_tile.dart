import 'package:flutter/material.dart';
import 'package:htlib/styles.dart';
import 'package:htlib/_internal/styled_widget.dart';

class BookElementTile extends StatefulWidget {
  final String? title;
  final String? content;
  final bool showDivider;
  final Widget Function(
    TextEditingController? controller,
    FocusNode focusNode,
  )? customContent;
  final Function(String newContent)? onEdit;
  final bool enableEditted;

  const BookElementTile({
    Key? key,
    this.title,
    this.content,
    this.customContent,
    this.showDivider = true,
    this.enableEditted = true,
    this.onEdit,
  }) : super(key: key);

  @override
  _BookElementTileState createState() => _BookElementTileState();
}

class _BookElementTileState extends State<BookElementTile> {
  TextEditingController? _controller;
  FocusNode _node = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController.fromValue(
        TextEditingValue(text: "${widget.content}"));
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.enableEditted,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          Row(
            children: [
              Flexible(
                flex: 2,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 2),
                    Text(
                      "${widget.title}",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ],
                ).center(),
              ),
              Container(
                color: Theme.of(context).dividerColor,
                width: 2,
                height: 300 / 7,
              ),
              Flexible(
                flex: 4,
                child: widget.customContent != null
                    ? widget.customContent!(_controller, _node)
                    : EditableText(
                        controller: _controller!,
                        focusNode: _node,
                        selectionColor:
                            Theme.of(context).primaryColor.withOpacity(0.4),
                        cursorColor: Colors.grey,
                        backgroundCursorColor: Colors.transparent,
                        onChanged: widget.onEdit,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground),
                        textAlign: TextAlign.center,
                        strutStyle: StrutStyle.fromTextStyle(
                            Theme.of(context).textTheme.subtitle1!),
                      ).center().padding(horizontal: Insets.sm),
              ),
            ],
          ),
          (widget.showDivider)
              ? Container(
                  height: 2,
                  color: Theme.of(context).dividerColor,
                  margin: EdgeInsets.symmetric(horizontal: Insets.m))
              : Container(),
        ],
      ).constrained(height: (300 - 2) / 4),
    );
  }
}
