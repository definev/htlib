import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:htlib/src/model/admin_user.dart';
import 'package:htlib/src/services/admin_service.dart';
import 'package:htlib/styles.dart';

class ProfileSection extends HookWidget {
  const ProfileSection({
    Key? key,
    required this.adminService,
  }) : super(key: key);

  final AdminService adminService;

  Widget _buildAdminUserField(
    BuildContext context, {
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        SizedBox(height: Insets.l),
        Text(
          title,
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        SizedBox(height: Insets.sm),
        Text(value, textAlign: TextAlign.center),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 224.0 + 12.0,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: Insets.m),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: Insets.m, bottom: 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Corners.s5),
                    child: Image.network(
                      adminService.currentUser.value.imageUrl!,
                      fit: BoxFit.cover,
                      height: double.maxFinite,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Insets.sm, vertical: 0.0),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _buildAdminUserField(context, title: "Họ và tên", value: adminService.currentUser.value.name),
                      _buildAdminUserField(context, title: "Email", value: adminService.currentUser.value.email),
                      _buildAdminUserField(context,
                          title: "Số điện thoại", value: adminService.currentUser.value.phone),
                      _buildAdminUserField(context,
                          title: "Vai trò",
                          value: adminService.currentUser.value.adminType == AdminType.librarian
                              ? "Thủ thư"
                              : "Lớp trưởng"),
                    ],
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
