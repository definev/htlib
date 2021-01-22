import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:htlib/app/modules/user_management/controllers/user_management_controller.dart';

class UserManagementView extends GetView<UserManagementController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UserManagementView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'UserManagementView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
