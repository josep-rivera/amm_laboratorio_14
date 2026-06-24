import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'task_view_model.dart';
import 'task_card.dart';
import 'task_form_view.dart';

class TaskListView extends StatefulWidget {
  const TaskListView({super.key});

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<TaskViewModel>().loadTasks(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        centerTitle: false,
        actions: [
          _TaskCountBadge(),
          const SizedBox(width: 8),
        ],
      ),
      body: _Body(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(TaskFormView.route()),
        icon: const Icon(Icons.add),
        label: const Text('New task'),
      ),
    );
  }
}

class _TaskCountBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<TaskViewModel, (int, int)>(
      selector: (_, vm) {
        final total = vm.tasks.length;
        final done = vm.tasks.where((t) => t.isCompleted).length;
        return (done, total);
      },
      builder: (context, (int done, int total) counts, _) {
        if (counts.$2 == 0) return const SizedBox.shrink();
        return Chip(
          label: Text('${counts.$1}/${counts.$2}'),
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
        );
      },
    );
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: context.read<TaskViewModel>(),
      builder: (context, _) {
        final vm = context.read<TaskViewModel>();

        if (vm.status == TaskStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (vm.status == TaskStatus.failure) {
          return _ErrorState(message: vm.errorMessage);
        }

        if (vm.tasks.isEmpty) {
          return const _EmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 88),
          itemCount: vm.tasks.length,
          itemBuilder: (context, i) {
            final task = vm.tasks[i];
            return TaskCard(
              task: task,
              onToggle: () => vm.toggleCompletion(task),
              onTap: () => Navigator.of(context).push(
                TaskFormView.route(task: task),
              ),
              onDelete: () => vm.deleteTask(task.id!),
            );
          },
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            size: 72,
            color: scheme.primary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No tasks yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: scheme.onSurface.withValues(alpha: 0.5),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to create your first task',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurface.withValues(alpha: 0.4),
                ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
          const SizedBox(height: 12),
          Text(message ?? 'Something went wrong'),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => context.read<TaskViewModel>().loadTasks(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
