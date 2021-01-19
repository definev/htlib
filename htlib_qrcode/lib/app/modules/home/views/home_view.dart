import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:htlib_qrcode/app/modules/home/controllers/home_controller.dart';
import 'package:htlib_qrcode/app/modules/home/views/htlib_tile.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeView'),
        centerTitle: true,
      ),
      body: Column(
        children: List.generate(
          4,
          (index) => HtlibTile(
            title: "Quét thêm sách",
            icon: Icons.qr_code_rounded,
            onTap: controller.qrcodeScan,
          ),
        ),
      ).paddingOnly(top: 5),
    );
  }
}
