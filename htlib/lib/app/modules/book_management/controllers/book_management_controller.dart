import 'package:get/get.dart';

class BookManagementController extends GetxController {
  var currentScreen = 0.obs;

  void goToPage(int page) => currentScreen.value = page;
}
