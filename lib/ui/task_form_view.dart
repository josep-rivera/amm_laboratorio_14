import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/task.dart';
import 'task_view_model.dart';

class TaskFormView extends StatefulWidget {
  const TaskFormView({super.key, this.task});

  final Task? task;

  static Route<void> route({Task? task}) => MaterialPageRoute(
        builder: (_) => TaskFormView(task: task),
      );

  @override
  State<TaskFormView> createState() => _TaskFormViewState();
}

class _TaskFormViewState extends State<TaskFormView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descriptionCtrl;
  bool _isSaving = false;

  bool get _isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.task?.title);
    _descriptionCtrl = TextEditingController(text: widget.task?.description);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final vm = context.read<TaskViewModel>();

    if (_isEditing) {
      await vm.updateTask(
        widget.task!.copyWith(
          title: _titleCtrl.text.trim(),
          description: _descriptionCtrl.text.trim(),
        ),
      );
    } else {
      await vm.createTask(
        title: _titleCtrl.text.trim(),
        description: _descriptionCtrl.text.trim(),
      );
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit task' : 'New task'),
        centerTitle: false,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _titleCtrl,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'What needs to be done?',
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Title is required' : null,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionCtrl,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'Add details…',
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: _isSaving ? null : _submit,
              child: _isSaving
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_isEditing ? 'Save changes' : 'Create task'),
            ),
          ],
        ),
      ),
    );
  }
}
