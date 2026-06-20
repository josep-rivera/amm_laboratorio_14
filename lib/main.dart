import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repositories/task_repository_impl.dart';
import 'data/services/database_service.dart';
import 'ui/core/app_theme.dart';
import 'ui/features/tasks/view_models/task_view_model.dart';
import 'ui/features/tasks/views/task_list_view.dart';

void main() {
  runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskViewModel(
        repository: TaskRepositoryImpl(
          databaseService: DatabaseService.instance,
        ),
      ),
      child: MaterialApp(
        title: 'Task Manager',
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        home: const TaskListView(),
      ),
    );
  }
}
