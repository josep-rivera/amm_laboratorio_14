import 'task.dart';
import 'task_repository.dart';
import 'database_service.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl({required DatabaseService databaseService})
      : _db = databaseService;

  final DatabaseService _db;

  static const _table = 'tasks';

  @override
  Future<List<Task>> getAll() async {
    final rows = await _db.query(_table, orderBy: 'created_at DESC');
    return rows.map(Task.fromMap).toList();
  }

  @override
  Future<Task> getById(int id) async {
    final rows = await _db.query(_table, where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) throw StateError('Task $id not found');
    return Task.fromMap(rows.first);
  }

  @override
  Future<Task> create(Task task) async {
    final id = await _db.insert(_table, task.toMap());
    return task.copyWith(id: id);
  }

  @override
  Future<Task> update(Task task) async {
    await _db.update(
      _table,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
    return task;
  }

  @override
  Future<void> delete(int id) async {
    await _db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }
}
