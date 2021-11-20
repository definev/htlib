import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String bookId;
  final String content;
  final double rating;
  final String senderId;
  final String commentBy;
  final String? imageUrl;
  final bool isAdmin;
  final Timestamp createdAt;
  Comment({
    this.imageUrl,
    required this.id,
    required this.bookId,
    required this.content,
    required this.rating,
    required this.senderId,
    required this.commentBy,
    required this.isAdmin,
    required this.createdAt,
  });

  Comment copyWith({
    String? id,
    String? bookId,
    String? content,
    double? rating,
    String? senderId,
    String? commentBy,
    String? imageUrl,
    bool? isAdmin,
    Timestamp? createdAt,
  }) {
    return Comment(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      content: content ?? this.content,
      rating: rating ?? this.rating,
      senderId: senderId ?? this.senderId,
      commentBy: commentBy ?? this.commentBy,
      imageUrl: imageUrl ?? this.imageUrl,
      isAdmin: isAdmin ?? this.isAdmin,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookId': bookId,
      'content': content,
      'rating': rating,
      'senderId': senderId,
      'commentBy': commentBy,
      'imageUrl': imageUrl,
      'isAdmin': isAdmin,
      'createdAt': createdAt,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'],
      bookId: map['bookId'],
      content: map['content'],
      rating: map['rating'].toDouble(),
      senderId: map['senderId'],
      commentBy: map['commentBy'],
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] : null,
      isAdmin: map['isAdmin'],
      createdAt: map['createdAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.decode(source));
}
