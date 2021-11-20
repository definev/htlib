import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:htlib/src/services/admin_service.dart';

final librarianPanelServiceProvider = Provider<LibrarianPanelService>((ref) => LibrarianPanelService());

class LibrarianPanelService {
  AdminService adminService = Get.find();

  void registerNewMornitor(BuildContext context, {required String email, required String password}) async {
    try {
      FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      // ignore: deprecated_member_use
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Có lỗi xảy ra email có thể đã được đăng kí.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void updatePasswordMornitor() async {}
}
