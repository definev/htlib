import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/src/services/user_service.dart';
import 'package:htlib/src/view/renting_history_management/components/dialog/widgets/date_picker_widget.dart';
import 'package:htlib/src/view/user_management/components/user_list_tile.dart';
import 'package:htlib/styles.dart';

class UserField extends StatefulWidget {
  final TextEditingController controller;
  final List<User> searchUserList;
  final String imgUrl;
  final Function(List<User> users) onSearch;
  final Function(User user) onSelectUser;
  final Function() onRemoveUser;
  final Function() onScanMode;
  final bool nullUser;
  final bool nullDate;
  final DatePickerWidget datePickerWidget;

  const UserField({
    Key key,
    this.controller,
    this.imgUrl,
    this.onSearch,
    this.searchUserList,
    this.onSelectUser,
    this.onRemoveUser,
    this.nullUser = false,
    this.nullDate = false,
    this.onScanMode,
    this.datePickerWidget,
  }) : super(key: key);

  @override
  _UserFieldState createState() => _UserFieldState();
}

class _UserFieldState extends State<UserField> {
  CrossFadeState crossFadeState = CrossFadeState.showFirst;
  UserService userService = Get.find<UserService>();
  double get imageHeight => 250;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              crossFadeState == CrossFadeState.showFirst
                  ? Container(
                      decoration: BoxDecoration(borderRadius: Corners.s5Border),
                      child: Column(
                        children: [
                          TextField(
                            controller: widget.controller,
                            decoration: InputDecoration(
                              hintText: "Tìm người mượn",
                              suffixIcon: IconButton(
                                icon: Icon(Icons.scanner),
                                onPressed: widget.onScanMode,
                              ),
                            ),
                            onChanged: (query) => widget.onSearch
                                ?.call(userService.search(query)),
                          ),
                          VSpace(1.0),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    bottom: Corners.s5Radius),
                                color: Theme.of(context).tileColor,
                              ),
                              child: widget.searchUserList.isEmpty
                                  ? Center(
                                      child: Text(
                                        "Không tìm thấy \n người mượn",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(height: 1.4),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : ListView.builder(
                                      itemBuilder: (context, index) =>
                                          UserListTile(
                                        widget.searchUserList[index],
                                        mode: UserListTileMode.short,
                                        onTap: () {
                                          widget.onSelectUser(
                                              widget.searchUserList[index]);
                                          setState(() {
                                            crossFadeState =
                                                CrossFadeState.showSecond;
                                          });
                                        },
                                      ),
                                      itemCount: widget.searchUserList.length,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : widget.imgUrl == null
                      ? Container()
                      : Stack(
                          children: [
                            Image(
                              image: CachedNetworkImageProvider(widget.imgUrl),
                              fit: BoxFit.cover,
                              height: double.maxFinite,
                              width: double.maxFinite,
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: EdgeInsets.all(14.0),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(
                                        Size(35.0, 35.0)),
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    size: FontSizes.s14,
                                  ),
                                  onPressed: () {
                                    widget.onRemoveUser();
                                    setState(() => crossFadeState =
                                        CrossFadeState.showFirst);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
              Align(
                alignment: Alignment.topCenter,
                child: AnimatedContainer(
                  duration: Durations.fast,
                  curve: Curves.decelerate,
                  height: widget.nullUser ? 50.0 : 0.0,
                  width: imageHeight - Insets.m,
                  margin: EdgeInsets.only(top: 48.0),
                  decoration: BoxDecoration(
                    borderRadius: Corners.s5Border,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Không được bỏ trống người dùng",
                    style: Theme.of(context).snackBarTheme.contentTextStyle,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  duration: Durations.fast,
                  curve: Curves.decelerate,
                  height: widget.nullDate == true ? 48.0 : 0.0,
                  width: imageHeight - Insets.m,
                  margin: EdgeInsets.only(bottom: Insets.sm),
                  decoration: BoxDecoration(
                    borderRadius: Corners.s5Border,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Không được bỏ trống hạn mượn",
                    style: Theme.of(context).snackBarTheme.contentTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.datePickerWidget != null) widget.datePickerWidget,
      ],
    );
  }
}
