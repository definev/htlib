import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:flutter/foundation.dart';
// import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:get/get.dart';

class FileUtils {
  static Future<Uint8List> image() async {
    if (!Platform.isWindows) {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["jpg", "png", "jpeg"],
      );

      return result?.files?.first?.bytes;
    } else {
      // User canceled the picker
      final file = OpenFilePicker()
        ..filterSpecification = {
          'Định dạng PNG': '*.png',
          'Định dạng JPG': '*.jpg',
          'Định dạng JPEG': '*.jpeg',
        }
        ..defaultFilterIndex = 0
        ..defaultExtension = 'png'
        ..title = 'Chọn ảnh đại diện';

      final result = file.getFile();
      if (result != null) {
        print(result.path);
        return result.readAsBytesSync();
      } else {
        return null;
      }
    }
  }

  static Future<List<dynamic>> excel() async {
    if (kIsWeb) {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["xlsx"],
      );

      if (result != null) {
        if (GetPlatform.isWeb) {
          List<Uint8List> _res = [];
          result.files.forEach((data) => _res.add(data.bytes));
          return _res;
        }
        List<File> _res = [];
        result.files.forEach((data) => _res.add(File(data.path)));

        return _res;
      } else {
        // User canceled the picker
        return [];
      }
    } else {
      return [];
      // final file = OpenFilePicker()
      //   ..filterSpecification = {
      //     'File XLSX(*.doc)': '*.xlsx',
      //   }
      //   ..defaultFilterIndex = 0
      //   ..defaultExtension = 'xlsx'
      //   ..title = 'Chọn file excel cũ';

      // final result = file.getFile();
      // if (result != null) {
      //   print(result.path);
      //   return result;
      // } else {
      //   return null;
      // }
    }
  }
}
