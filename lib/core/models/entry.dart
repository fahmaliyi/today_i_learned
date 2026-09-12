import 'dart:convert';

class Entry {
  final String id;
  final String title;
  final String body;
  final List<String> tags;
  final DateTime createdAt;

  const Entry({
    required this.id,
    required this.title,
    required this.body,
    required this.tags,
    required this.createdAt,
  });

  Entry copyWith({
    String? id,
    String? title,
    String? body,
    List<String>? tags,
    DateTime? createdAt,
  }) {
    return Entry(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'tags': tags,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Entry.fromJson(Map<String, dynamic> json) => Entry(
    id: json['id'] as String,
    title: json['title'] as String,
    body: json['body'] as String,
    tags: List<String>.from(json['tags'] as List),
    createdAt: DateTime.parse(json['createdAt'] as String),
  );

  static String encodeList(List<Entry> entries) =>
      jsonEncode(entries.map((e) => e.toJson()).toList());

  static List<Entry> decodeList(String raw) {
    final list = jsonDecode(raw) as List;
    return list.map((e) => Entry.fromJson(e as Map<String, dynamic>)).toList();
  }
}
