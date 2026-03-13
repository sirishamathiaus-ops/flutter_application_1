import 'package:flutter/material.dart';

class Note {
  String title;
  String content;
  DateTime createdAt;
  bool isPinned;
  Color color;

  Note({
    required this.title,
    required this.content,
    required this.createdAt,
    this.isPinned = false,
    this.color = const Color(0xFFFFF9C4),
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
        'isPinned': isPinned,
        'color': color.value,
      };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        title: json['title'],
        content: json['content'],
        createdAt: DateTime.parse(json['createdAt']),
        isPinned: json['isPinned'] ?? false,
        color: Color(json['color'] ?? 0xFFFFF9C4),
      );
}