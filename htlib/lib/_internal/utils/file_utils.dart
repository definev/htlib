import 'package:htlib/_internal/director/filepicker_windows.dart'
    if (dart.library.io) 'package:filepicker_windows/filepicker_windows.dart';
import 'package:universal_io/io.dart' as io;
import 'package:universal_html/html.dart' as html;
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageFile {
  final String extensions;
  final PickedFile image;
  final html.File webImage;

  ImageFile(this.extensions, {this.image, this.webImage});
}

Future<html.File> imagePickerWeb() async {
  // HTML input element
  html.InputElement uploadInput = html.FileUploadInputElement();
  uploadInput.click();
  uploadInput.accept = "image/*";

  await uploadInput.onChange.first;

  final file = uploadInput.files.first;
  final reader = html.FileReader();
  reader.readAsDataUrl(file);

  return file;
}

class FileUtils {
  static Future<ImageFile> imagePicker(ImageSource source) async {
    if (kIsWeb) {
      var img = await imagePickerWeb();

      List<String> spt = img.name.split(".");

      return ImageFile(".${spt.last}", webImage: img);
    }

    var img = await ImagePicker().getImage(source: source);
    if (img == null) return null;
    List<String> spt = img.path.split(".");

    return ImageFile(".${spt.last}", image: img);
  }

  static Future<ImageFile> image(ImageSource source) async =>
      imagePicker(source);

  static Future<List<dynamic>> excel() async {
    if (io.Platform.isWindows) {
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
        return [result];
      } else {}
    }

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
      List<io.File> _res = [];
      result.files.forEach((data) => _res.add(io.File(data.path)));

      return _res;
    } else {
      // User canceled the picker
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
      //   return [result];
      // } else {
      // }
    }
  }
}
