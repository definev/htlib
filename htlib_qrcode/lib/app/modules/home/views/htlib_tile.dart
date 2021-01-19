import 'package:flutter/material.dart';

import 'package:get/get.dart';

class HtlibTile extends GetView {
  final String title;
  final IconData icon;
  final Function() onTap;

  HtlibTile({
    this.title,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.14),
                blurRadius: 5,
              )
            ],
          ),
          height: (Get.height - 24 - 56 - 45) / 4,
          width: Get.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon),
              SizedBox(width: 5),
              Text(title),
            ],
          ).paddingSymmetric(horizontal: 20)),
    ).paddingOnly(bottom: 10).paddingSymmetric(horizontal: 10);
  }
}
