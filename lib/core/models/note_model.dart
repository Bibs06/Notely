class NoteModel {
  final int? id;
  final String title;
  final String description;
  final int subjectId;   // 🔥 Foreign Key
  final String createdAt;

  NoteModel({
    this.id,
    required this.title,
    required this.description,
    required this.subjectId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'subject_id': subjectId,
      'created_at': createdAt,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      subjectId: map['subject_id'],
      createdAt: map['created_at'],
    );
  }
}