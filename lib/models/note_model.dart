import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  String title;
  
  @HiveField(2)
  String content;
  
  @HiveField(3)
  DateTime createdAt;
  
  @HiveField(4)
  DateTime updatedAt;
  
  @HiveField(5)
  bool isPinned;
  
  @HiveField(6)
  bool isArchived;
  
  @HiveField(7)
  String category;
  
  @HiveField(8)
  String? aiSummary;
  
  @HiveField(9)
  List<String> keywords;
  
  @HiveField(10)
  bool isSynced;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.isPinned = false,
    this.isArchived = false,
    this.category = 'All',
    this.aiSummary,
    this.keywords = const [],
    this.isSynced = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isPinned': isPinned,
      'isArchived': isArchived,
      'category': category,
      'aiSummary': aiSummary,
      'keywords': keywords,
      'isSynced': isSynced,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      isPinned: map['isPinned'] ?? false,
      isArchived: map['isArchived'] ?? false,
      category: map['category'] ?? 'All',
      aiSummary: map['aiSummary'],
      keywords: List<String>.from(map['keywords'] ?? []),
      isSynced: map['isSynced'] ?? false,
    );
  }

  Note copyWith({
    String? title,
    String? content,
    DateTime? updatedAt,
    bool? isPinned,
    bool? isArchived,
    String? category,
    String? aiSummary,
    List<String>? keywords,
    bool? isSynced,
  }) {
    return Note(
      id: this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
      category: category ?? this.category,
      aiSummary: aiSummary ?? this.aiSummary,
      keywords: keywords ?? this.keywords,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
