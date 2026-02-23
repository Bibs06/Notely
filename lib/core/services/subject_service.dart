import 'package:notely/core/models/message_model.dart';
import 'package:notely/core/models/note_model.dart';
import 'package:notely/core/models/subject_model.dart';
import 'package:notely/core/services/database/db_helper.dart';

class SubjectService {
  static Future<MessageModel?> addSubject(SubjectModel subject) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final id = await db.insert('Subjects', subject.toMap());

      if (id > 0) {
        return MessageModel(
          message: "Subject added successfully",
          success: true,
        );
      } else {
        return MessageModel(message: "Failed to add subject", success: false);
      }
    } catch (e) {
      return MessageModel(message: e.toString(), success: false);
    }
  }

  static Future<List<SubjectModel>> getAllSubjects() async {
    try {
      final db = await DatabaseHelper.instance.database;

      final result = await db.query('Subjects', orderBy: 'created_at DESC');

      return result.map((e) => SubjectModel.fromMap(e)).toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<MessageModel?> deleteSubject(int id) async {
  try {
    final db = await DatabaseHelper.instance.database;

    final count = await db.delete(
      'Subjects',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (count > 0) {
      return MessageModel(
        message: "Subject deleted successfully",
        success: true,
      );
    } else {
      return MessageModel(
        message: "Subject not found",
        success: false,
      );
    }
  } catch (e) {
    return MessageModel(message: e.toString(), success: false);
  }
}

static Future<MessageModel?> updateSubject(SubjectModel subject) async {
  try {
    final db = await DatabaseHelper.instance.database;

    final count = await db.update(
      'Subjects',
      subject.toMap(),
      where: 'id = ?',
      whereArgs: [subject.id],
    );

    if (count > 0) {
      return MessageModel(
        message: "Subject updated successfully",
        success: true,
      );
    } else {
      return MessageModel(
        message: "Subject not found",
        success: false,
      );
    }
  } catch (e) {
    return MessageModel(message: e.toString(), success: false);
  }
}
}
