import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:get/get.dart';

class FileUtils {
  static Future<dynamic> excel() async {
    if (GetPlatform.isWindows) {
      final file = OpenFilePicker()
        ..filterSpecification = {
          'File XLSX(*.doc)': '*.xlsx',
        }
        ..defaultFilterIndex = 0
        ..defaultExtension = 'xlsx'
        ..title = 'Chọn file excel cũ';

      final result = file.getFile();
      if (result != null) {
        print(result.path);
        return result;
      } else {
        return;
      }
    }

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
