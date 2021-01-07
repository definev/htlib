import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:htlib_admin/domain/book/entities/book.dart';

class LocalBook {
  Future<List<Book>> getBookList() async {
    String rawJson =
        await rootBundle.loadString('assets/json_mock/book_list.json');
    var json = jsonDecode(rawJson);

    return json.map((data) => Book.fromJson(data)).toList();
  }
}
