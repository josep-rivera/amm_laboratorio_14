import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/database_service.dart';
import 'data/task_repository_impl.dart';
import 'ui/app_theme.dart';
import 'ui/task_list_view.dart';
import 'ui/task_view_model.dart';

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
