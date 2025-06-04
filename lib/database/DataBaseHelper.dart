import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/task.dart';
import '../../models/user.dart';

class DatabaseHelper {
  static const _databaseName = "tasks_database.db";
  static const _databaseVersion = 1;

  static const table = 'tasks';
  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnDescription = 'description';
  static const columnIsCompleted = 'isCompleted';
  static const columnUserId = 'userId';

  static const userTable = 'users';
  static const userId = 'id';
  static const userEmail = 'email';
  static const userPassword = 'password';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $userTable (
        $userId TEXT PRIMARY KEY,
        $userEmail TEXT UNIQUE NOT NULL,
        $userPassword TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $table (
        $columnId TEXT PRIMARY KEY,
        $columnTitle TEXT NOT NULL,
        $columnDescription TEXT NOT NULL,
        $columnIsCompleted INTEGER NOT NULL,
        $columnUserId TEXT NOT NULL,
        FOREIGN KEY ($columnUserId) REFERENCES $userTable ($userId)
      )
    ''');
  }

  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert(table, task.toMap());
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final maps = await db.query(table);
    return maps.map((map) => Task.fromMap(map)).toList();
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      table,
      task.toMap(),
      where: '$columnId = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(String id) async {
    final db = await database;
    return await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllTasks() async {
    final db = await database;
    return await db.delete(table);
  }

  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert(userTable, user.toMap());
  }

  Future<User?> authenticate(String email, String password) async {
    final db = await database;
    final result = await db.query(
      userTable,
      where: '$userEmail = ? AND $userPassword = ?',
      whereArgs: [email, password],
    );
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final result = await db.query(userTable);
    return result.map((map) => User.fromMap(map)).toList();
  }
}
