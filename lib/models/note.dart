import 'package:cloud_firestore/cloud_firestore.dart';

enum NoteColor {
  yellow,
  pink,
  blue,
  green,
  orange,
  purple,
}

class Note {
  final String id;
  final String title;
  final String content;
  final String? source;
  final bool isPinned;
  final NoteColor color;
  final List<String> labels;
  final bool isArchived;
  final bool isDeleted;
  final DateTime? reminderDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    this.source,
    this.isPinned = false,
    this.color = NoteColor.yellow,
    this.labels = const [],
    this.isArchived = false,
    this.isDeleted = false,
    this.reminderDate,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create Note from Firestore document
  factory Note.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return Note(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      source: data['source'],
      isPinned: data['isPinned'] ?? false,
      color: NoteColor.values.firstWhere(
        (e) => e.name == data['color'],
        orElse: () => NoteColor.yellow,
      ),
      labels: List<String>.from(data['labels'] ?? []),
      isArchived: data['isArchived'] ?? false,
      isDeleted: data['isDeleted'] ?? false,
      reminderDate: data['reminderDate'] != null 
          ? (data['reminderDate'] as Timestamp).toDate()
          : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Convert Note to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'source': source,
      'isPinned': isPinned,
      'color': color.name,
      'labels': labels,
      'isArchived': isArchived,
      'isDeleted': isDeleted,
      'reminderDate': reminderDate != null 
          ? Timestamp.fromDate(reminderDate!)
          : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Create a copy of Note with updated fields
  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? source,
    bool? isPinned,
    NoteColor? color,
    List<String>? labels,
    bool? isArchived,
    bool? isDeleted,
    DateTime? reminderDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      source: source ?? this.source,
      isPinned: isPinned ?? this.isPinned,
      color: color ?? this.color,
      labels: labels ?? this.labels,
      isArchived: isArchived ?? this.isArchived,
      isDeleted: isDeleted ?? this.isDeleted,
      reminderDate: reminderDate ?? this.reminderDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper method to check if note is active (not archived or deleted)
  bool get isActive => !isArchived && !isDeleted;

  // Helper method to get color as Material color
  int get colorValue {
    switch (color) {
      case NoteColor.yellow:
        return 0xFFFFF59D; // Light yellow
      case NoteColor.pink:
        return 0xFFF8BBD9; // Light pink
      case NoteColor.blue:
        return 0xFFBBDEFB; // Light blue
      case NoteColor.green:
        return 0xFFC8E6C9; // Light green
      case NoteColor.orange:
        return 0xFFFFCC80; // Light orange
      case NoteColor.purple:
        return 0xFFE1BEE7; // Light purple
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Note && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Note(id: $id, title: $title, content: $content, isPinned: $isPinned, color: $color)';
  }
}

// Data classes for creating and updating notes
class CreateNoteData {
  final String title;
  final String content;
  final String? source;
  final bool isPinned;
  final NoteColor color;
  final List<String> labels;
  final DateTime? reminderDate;

  const CreateNoteData({
    required this.title,
    required this.content,
    this.source,
    this.isPinned = false,
    this.color = NoteColor.yellow,
    this.labels = const [],
    this.reminderDate,
  });
}

class UpdateNoteData {
  final String? title;
  final String? content;
  final String? source;
  final bool? isPinned;
  final NoteColor? color;
  final List<String>? labels;
  final bool? isArchived;
  final bool? isDeleted;
  final DateTime? reminderDate;

  const UpdateNoteData({
    this.title,
    this.content,
    this.source,
    this.isPinned,
    this.color,
    this.labels,
    this.isArchived,
    this.isDeleted,
    this.reminderDate,
  });
}
