import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/styled_components/buttons/colored_icon_button.dart';
import 'package:htlib/styles.dart';
import 'package:htlib/themes.dart';

class GroupTextFieldChip extends StatelessWidget {
  final String text;
  final Function() onTap;
  final Function() onClear;

  const GroupTextFieldChip({Key key, this.text, this.onTap, this.onClear})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Get.find<Rx<AppTheme>>().value;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: theme.greyWeak, width: 2),
              borderRadius: Corners.s5Border,
              color: Colors.transparent,
            ),
            child: TextStyles.T1Text("$text", color: Colors.black),
          ),
        ),
        HSpace(Insets.sm),
        ColorShiftIconBtn(
          AntDesign.close,
          color: Colors.white,
          bgColor: theme.accent1,
          onPressed: onClear,
        ),
      ],
    );
  }
}
