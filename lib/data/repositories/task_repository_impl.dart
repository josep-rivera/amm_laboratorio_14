import '../../domain/models/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../models/task_model.dart';
import '../services/database_service.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl({required DatabaseService databaseService})
      : _db = databaseService;

  final DatabaseService _db;

  static const _table = 'tasks';

  @override
  Future<List<Task>> getAll() async {
    final rows = await _db.query(_table, orderBy: 'created_at DESC');
    return rows.map((r) => TaskModel.fromMap(r).toDomain()).toList();
  }

  @override
  Future<Task> getById(int id) async {
    final rows = await _db.query(_table, where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) throw StateError('Task $id not found');
    return TaskModel.fromMap(rows.first).toDomain();
  }

  @override
  Future<Task> create(Task task) async {
    final model = TaskModel.fromDomain(task);
    final id = await _db.insert(_table, model.toMap());
    return task.copyWith(id: id);
  }

  @override
  Future<Task> update(Task task) async {
    final model = TaskModel.fromDomain(task);
    await _db.update(
      _table,
      model.toMap(),
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
