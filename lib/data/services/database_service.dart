import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  DatabaseService._();

  static final DatabaseService instance = DatabaseService._();

  static Database? _db;

  Future<Database> get database async {
    _db ??= await _init();
    return _db!;
  }

  Future<Database> _init() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'task_manager.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT,
            is_completed INTEGER NOT NULL DEFAULT 0,
            created_at TEXT NOT NULL
          )
        ''');
        await _seed(db);
      },
    );
  }

  Future<void> _seed(Database db) async {
    final now = DateTime.now();
    final rows = [
      ('Buy groceries', 'Milk, eggs, bread, and coffee', false, now.subtract(const Duration(days: 2))),
      ('Read Clean Architecture', 'Chapters 4 through 6 — SOLID principles', false, now.subtract(const Duration(days: 1))),
      ('Fix login bug', 'Token refresh fails silently on 401 — check interceptor', true, now.subtract(const Duration(hours: 5))),
      ('Write unit tests', 'Cover TaskRepositoryImpl with in-memory DB', false, now.subtract(const Duration(hours: 2))),
      ('Call the dentist', null, true, now.subtract(const Duration(hours: 1))),
    ];

    for (final (title, description, isCompleted, createdAt) in rows) {
      await db.insert('tasks', {
        'title': title,
        'description': description,
        'is_completed': isCompleted ? 1 : 0,
        'created_at': createdAt.toIso8601String(),
      });
    }
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await database;
    return db.insert(table, values, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
  }) async {
    final db = await database;
    return db.query(table, where: where, whereArgs: whereArgs, orderBy: orderBy);
  }

  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    required String where,
    required List<Object?> whereArgs,
  }) async {
    final db = await database;
    return db.update(table, values, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(
    String table, {
    required String where,
    required List<Object?> whereArgs,
  }) async {
    final db = await database;
    return db.delete(table, where: where, whereArgs: whereArgs);
  }
}
