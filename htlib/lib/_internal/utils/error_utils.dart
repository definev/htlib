import 'dart:developer';

import 'dart:io';

class ErrorLog {
  final String from;
  final String func;

  ErrorLog({this.from, this.func});

  ErrorLog copyWith({String from, String func}) => ErrorLog(
        from: from ?? this.from,
        func: func ?? this.func,
      );
}
