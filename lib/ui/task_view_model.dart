import 'package:flutter/foundation.dart';

import '../data/task.dart';
import '../data/task_repository.dart';

enum TaskStatus { initial, loading, success, failure }

class TaskViewModel extends ChangeNotifier {
  TaskViewModel({required this._repository});

  final TaskRepository _repository;

  List<Task> _tasks = [];
  List<Task> get tasks => List.unmodifiable(_tasks);

  TaskStatus _status = TaskStatus.initial;
  TaskStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadTasks() async {
    _setStatus(TaskStatus.loading);
    try {
      _tasks = await _repository.getAll();
      _setStatus(TaskStatus.success);
    } catch (e) {
      _errorMessage = e.toString();
      _setStatus(TaskStatus.failure);
    }
  }

  Future<void> createTask({required String title, String? description}) async {
    final task = Task(
      title: title,
      description: description?.isEmpty == true ? null : description,
      createdAt: DateTime.now(),
    );
    try {
      final created = await _repository.create(task);
      _tasks = [created, ..._tasks];
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _setStatus(TaskStatus.failure);
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      final updated = await _repository.update(task);
      _tasks = _tasks.map((t) => t.id == updated.id ? updated : t).toList();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _setStatus(TaskStatus.failure);
    }
  }

  Future<void> toggleCompletion(Task task) async {
    await updateTask(task.copyWith(isCompleted: !task.isCompleted));
  }

  Future<void> deleteTask(int id) async {
    try {
      await _repository.delete(id);
      _tasks = _tasks.where((t) => t.id != id).toList();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _setStatus(TaskStatus.failure);
    }
  }

  void _setStatus(TaskStatus status) {
    _status = status;
    notifyListeners();
  }
}
