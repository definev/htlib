import 'dart:developer' as dev;
import 'dart:io';

import 'package:htlib_admin/_internal/utils/path_utils.dart';
import 'package:path/path.dart' as p;

import 'universal_file.dart';

void log(String msg) => dev.log(msg, name: "IO_WRITER");

class IoFileWriter implements UniversalFile {
  static void createDirIfNotExists(Directory dir) async {
    //Create directory if it doesn't exist
    if (dir != null && !await dir.exists()) {
      //Catch error since disk io can always fail.
      await dir.create(recursive: true).catchError((e, stack) => log(e));
    }
  }

  Directory dataPath;

  @override
  String fileName;

  IoFileWriter(this.fileName);

  String get fullPath => p.join(dataPath.path, fileName);

  Future getDataPath() async {
    if (dataPath != null) return;
    dataPath = Directory(await PathUtil.dataPath);
    if (Platform.isWindows || Platform.isLinux) {
      createDirIfNotExists(dataPath);
    }
  }

  @override
  Future<String> read() async {
    await getDataPath();
    return await File("$fullPath").readAsString().catchError(log);
  }

  @override
  Future write(String value, [bool append = false]) async {
    await getDataPath();
    await File("$fullPath")
        .writeAsString(
          value,
          mode: append ? FileMode.append : FileMode.write,
        )
        .catchError(log);
  }

  UniversalFile getPlatformFileWriter(String string) => IoFileWriter(string);
}
