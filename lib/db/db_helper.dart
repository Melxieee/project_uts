import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:project_uts/model/note.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  static Database? _database;

  final String tableName = 'tableNote';
  final String columnId = 'id';
  final String columnTitle = 'title';
  final String columnDate = 'date';
  final String columnNote = 'note';

  DbHelper._internal();
  factory DbHelper() => _instance;

  Future<Database?> get _db async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDb();
    return _database;
  }

  Future<Database?> _initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'note_db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    var sql =
        "CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY,"
        "$columnTitle TEXT,"
        "$columnDate TEXT,"
        "$columnNote TEXT)";
    await db.execute(sql);
  }

  Future<int?> saveNote(Note note) async {
    var dbClient = await _db;
    return await dbClient!.insert(tableName, note.toMap());
  }

  Future<List?> getAllNote() async {
    var dbClient = await _db;
    var result = await dbClient!.query(
      tableName,
      columns: [columnId, columnTitle, columnDate, columnNote],
      orderBy: '$columnId DESC',
    );
    return result.toList();
  }

  Future<int?> updateNote(Note note) async {
    var dbClient = await _db;
    return await dbClient!.update(
      tableName,
      note.toMap(),
      where: '$columnId = ?',
      whereArgs: [note.id],
    );
  }

  Future<int?> deleteNote(int id) async {
    var dbClient = await _db;
    return await dbClient!.delete(
      tableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
