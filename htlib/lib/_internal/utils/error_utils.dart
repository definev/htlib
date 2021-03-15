import 'dart:developer';

import 'dart:io';

class ErrorLog {
  final String? from;
  final String? func;

  ErrorLog({this.from, this.func});

  ErrorLog copyWith({String? from, String? func}) => ErrorLog(
        from: from ?? this.from,
        func: func ?? this.func,
      );
}

class ErrorUtils {
  static T? errorCatch<T>(
    T Function() logic, {
    T Function()? onError,
    ErrorLog? errorLog,
  }) {
    try {
      return logic();
    } catch (e) {
      if (errorLog != null)
        log(
          "${errorLog.func}: $e",
          name: "${errorLog.from}",
          time: DateTime.now(),
        );
      return onError?.call();
    }
  }

  static Future<void> catchNetworkError(
      {Function()? onConnected, Function()? onError}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await onConnected?.call();
      }
    } on SocketException catch (_) {
      await onError?.call();
    }
  }
}
