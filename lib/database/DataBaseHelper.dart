import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/task.dart';

class DatabaseHelper {
  static const _databaseName = "tasks_database.db";
  static const _databaseVersion = 1;

  static const table = 'tasks';
  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnDescription = 'description';
  static const columnIsCompleted = 'isCompleted';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId TEXT PRIMARY KEY,
        $columnTitle TEXT NOT NULL,
        $columnDescription TEXT NOT NULL,
        $columnIsCompleted INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insertTask(Task task) async {
    Database db = await database;
    return await db.insert(
      table,
      {
        columnId: task.id,
        columnTitle: task.title,
        columnDescription: task.description,
        columnIsCompleted: task.isCompleted ? 1 : 0,
      },
    );
  }

  Future<List<Task>> getTasks() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(table);
    
    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i][columnId],
        title: maps[i][columnTitle],
        description: maps[i][columnDescription],
        isCompleted: maps[i][columnIsCompleted] == 1,
      );
    });
  }

  Future<int> updateTask(Task task) async {
    Database db = await database;
    return await db.update(
      table,
      {
        columnTitle: task.title,
        columnDescription: task.description,
        columnIsCompleted: task.isCompleted ? 1 : 0,
      },
      where: '$columnId = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(String id) async {
    Database db = await database;
    return await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllTasks() async {
    Database db = await database;
    return await db.delete(table);
  }
}