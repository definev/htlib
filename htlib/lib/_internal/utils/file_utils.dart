import 'dart:io' as io;
import 'package:universal_html/html.dart' as html;
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
// import 'package:filepicker_windows/filepicker_windows.dart';
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
  // The FileReader object lets web applications asynchronously read the
  // contents of files (or raw data buffers) stored on the user's computer,
  // using File or Blob objects to specify the file or data to read.
  // Source: https://developer.mozilla.org/en-US/docs/Web/API/FileReader

  reader.readAsDataUrl(file);
  // The readAsDataURL method is used to read the contents of the specified Blob or File.
  //  When the read operation is finished, the readyState becomes DONE, and the loadend is
  // triggered. At that time, the result attribute contains the data as a data: URL representing
  // the file's data as a base64 encoded string.
  // Source: https://developer.mozilla.org/en-US/docs/Web/API/FileReader/readAsDataURL

  await reader.onLoadEnd.first;

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

  static Future<ImageFile> image(ImageSource source) async {
    return imagePicker(source);
    // User canceled the picker
    // final file = OpenFilePicker()
    //   ..filterSpecification = {
    //     'Định dạng PNG': '*.png',
    //     'Định dạng JPG': '*.jpg',
    //     'Định dạng JPEG': '*.jpeg',
    //     'Ảnh': "*.*",
    //   }
    //   ..defaultFilterIndex = 0
    //   ..defaultExtension = 'png'
    //   ..title = 'Chọn ảnh đại diện';

    // final result = file.getFile();
    // if (result != null) {
    //   print(result.path);
    //   return result.readAsBytesSync();
    // } else {
    // }
  }

  static Future<List<dynamic>> excel() async {
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
