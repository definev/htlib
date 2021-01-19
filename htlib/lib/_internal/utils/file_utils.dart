import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class FileUtils {
  static Future<dynamic> excel() async {
    FilePickerResult result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["xlsx"]);

    if (result != null) {
      if (GetPlatform.isWeb) return result.files.first.bytes;

      File file = File(result.files.first.path);
      return file;
    } else {
      // User canceled the picker
      return null;
    }
  }
}
