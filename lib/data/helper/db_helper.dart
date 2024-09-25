import 'package:planner_app/data/model/User.dart';
import 'package:planner_app/data/model/task_model.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton pattern
  static final DatabaseHelper _databaseService = DatabaseHelper._internal();
  factory DatabaseHelper() => _databaseService;
  DatabaseHelper._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'db_product.db');
    // ignore: avoid_print
    print(
        "Đường dẫn database: $databasePath"); // in đường dẫn chứa file database
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user(
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        email TEXT UNIQUE, 
        password TEXT
      );
      ''');
       await db.execute('''
      CREATE TABLE task(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        date TEXT,
        content TEXT,
        startTime TEXT,
        endTime TEXT,
        location TEXT,
        leader TEXT,
        notes TEXT,
        status TEXT,
        userId INTEGER,
        FOREIGN KEY(userId) REFERENCES user(id) ON DELETE CASCADE
      );
    ''');
  }

  // CRUD cho UserModel
  // Thêm người dùng mới
  Future<void> insertUser(String email, String password) async {
    final db = await _databaseService.database;
    await db.insert(
      'user',
      {'email': email, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Lấy người dùng dựa trên email và mật khẩu (đăng nhập)
  Future<UserModel?> getUser(String email, String password) async {
  final db = await _databaseService.database;
  final List<Map<String, dynamic>> maps = await db.query(
    'user', // Ensure this table name is correct
    where: 'email = ? AND password = ?',
    whereArgs: [email, password],
  );

  if (maps.isNotEmpty) {
    return UserModel.fromMap(maps.first);
  }
  return null; // Return null if no user found
}

  // Xóa người dùng (ví dụ: nếu muốn xóa tài khoản)
  Future<void> deleteUser(int id) async {
    final db = await _databaseService.database;
    await db.delete(
      'user',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //CRUD for TaskModel
  // Insert new task
  Future<void> insertTask(TaskModel task) async {
    final db = await _databaseService.database;
    await db.insert(
      'task',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all tasks for a specific user
  // Future<List<TaskModel>> getTasks(int userId) async {
  //   final db = await _databaseService.database;
  //   final List<Map<String, dynamic>> tasks = await db.query(
  //     'task',
  //     where: 'userId = ?',
  //     whereArgs: [userId],
  //   );

  //   return tasks.map((task) => TaskModel.fromMap(task)).toList();
  // }
  Future<List<TaskModel>> getTasks(int? userId) async {
  final db = await _databaseService.database;
  
  // Determine the query condition based on whether userId is provided or not
  String? whereClause;
  List<dynamic>? whereArgs;

  if (userId != null) {
    whereClause = 'userId = ?';
    whereArgs = [userId];
  }

  final List<Map<String, dynamic>> tasks = await db.query(
    'task',
    where: whereClause,
    whereArgs: whereArgs,
  );

  return tasks.isNotEmpty
      ? tasks.map((task) => TaskModel.fromMap(task)).toList()
      : []; // Return an empty list if no tasks are found
}

  // Update a task
  Future<void> updateTask(TaskModel task) async {
    final db = await _databaseService.database;
    await db.update(
      'task',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  //update status task 
  Future<void> updateTaskStatus(int id, String newStatus) async {
    final db = await database; // Your database instance
    await db.update(
      'task', // Your table name
      {'status': newStatus},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  // Delete a task
  Future<void> deleteTask(int id) async {
    final db = await _databaseService.database;
    await db.delete(
      'task',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
