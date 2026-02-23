import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notely.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB,onConfigure: (db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  },);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        subject_id INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (subject_id) REFERENCES Subjects(id) ON DELETE CASCADE


      )
    ''');
    await db.execute('''
      CREATE TABLE Subjects (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }
}
