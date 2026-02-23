import 'package:notely/core/models/message_model.dart';
import 'package:notely/core/models/note_model.dart';
import 'package:notely/core/services/database/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class NoteService {
  static Future<MessageModel?> addNote(NoteModel note) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final id = await db.insert('Notes', note.toMap());

      if (id > 0) {
        return MessageModel(message: "Note added successfully", success: true);
      } else {
        return MessageModel(message: "Failed to add note", success: false);
      }
    } catch (e) {
      return MessageModel(message: e.toString(), success: false);
    }
  }

  static Future<List<NoteModel>> getNotesBySubject({
    required int subjectId,
    required int page,
    required int limit,
  }) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final offset = (page - 1) * limit;

      final result = await db.query(
        'Notes',
        where: 'subject_id = ?',
        whereArgs: [subjectId],
        orderBy: 'created_at DESC',
        limit: limit,
        offset: offset,
      );

      return result.map((e) => NoteModel.fromMap(e)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<MessageModel> updateNote(NoteModel note) async {
    try {
      final db = await DatabaseHelper.instance.database;

      final count = await db.update(
        'Notes',
        note.toMap(),
        where: 'id = ?',
        whereArgs: [note.id],
      );

      if (count > 0) {
        return MessageModel(message: "Note updated", success: true);
      } else {
        return MessageModel(message: "Note not found", success: false);
      }
    } catch (e) {
      return MessageModel(message: e.toString(), success: false);
    }
  }

  static Future<MessageModel> deleteNote(int id) async {
    try {
      final db = await DatabaseHelper.instance.database;

      final count = await db.delete('Notes', where: 'id = ?', whereArgs: [id]);

      if (count > 0) {
        return MessageModel(message: "Note deleted", success: true);
      } else {
        return MessageModel(message: "Note not found", success: false);
      }
    } catch (e) {
      return MessageModel(message: e.toString(), success: false);
    }
  }

  static Future<int> getTotalNoteCount(int subjectId) async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM Notes WHERE subject_id = ?',
      [subjectId],
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }
}
