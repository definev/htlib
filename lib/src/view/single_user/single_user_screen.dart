import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htlib/src/services/single_user_service.dart';
import 'package:htlib/src/view/user_management/components/user_screen.dart';

class SingleUserScreen extends StatefulWidget {
  const SingleUserScreen({Key? key}) : super(key: key);

  @override
  _SingleUserScreenState createState() => _SingleUserScreenState();
}

class _SingleUserScreenState extends State<SingleUserScreen> {
  SingleUserService singleUserService = Get.find();

  @override
  Widget build(BuildContext context) {
    return UserScreen(
      singleUserService.user,
      primary: true,
    );
  }
}
