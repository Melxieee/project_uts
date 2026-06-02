import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:project_uts/model/note.dart';
import 'package:project_uts/model/task.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  static Database? _database;

  final String tableName = 'tableNote';
  final String columnId = 'id';
  final String columnTitle = 'title';
  final String columnDate = 'date';
  final String columnNote = 'note';

  final String tableTask = 'tableTask';
  final String columnTaskId = 'id';
  final String columnTaskTitle = 'title';
  final String columnTaskIsCompleted = 'isCompleted';
  final String columnTaskReminder = 'reminder';

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

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    var sqlNote =
        "CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY,"
        "$columnTitle TEXT,"
        "$columnDate TEXT,"
        "$columnNote TEXT)";
    await db.execute(sqlNote);

    var sqlTask =
        "CREATE TABLE $tableTask($columnTaskId INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$columnTaskTitle TEXT,"
        "$columnTaskIsCompleted INTEGER,"
        "$columnTaskReminder TEXT)";
    await db.execute(sqlTask);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      var sqlTask =
          "CREATE TABLE $tableTask($columnTaskId INTEGER PRIMARY KEY AUTOINCREMENT,"
          "$columnTaskTitle TEXT,"
          "$columnTaskIsCompleted INTEGER,"
          "$columnTaskReminder TEXT)";
      await db.execute(sqlTask);
    }
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

  // --- Task DB Operations ---

  Future<int?> saveTask(Task task) async {
    var dbClient = await _db;
    return await dbClient!.insert(tableTask, task.toMap());
  }

  Future<List?> getAllTask() async {
    var dbClient = await _db;
    var result = await dbClient!.query(
      tableTask,
      orderBy: '$columnTaskId DESC',
    );
    return result.toList();
  }

  Future<int?> updateTask(Task task) async {
    var dbClient = await _db;
    return await dbClient!.update(
      tableTask,
      task.toMap(),
      where: '$columnTaskId = ?',
      whereArgs: [task.id],
    );
  }

  Future<int?> deleteTask(int id) async {
    var dbClient = await _db;
    return await dbClient!.delete(
      tableTask,
      where: '$columnTaskId = ?',
      whereArgs: [id],
    );
  }
}
