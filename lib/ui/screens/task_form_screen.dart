import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/task.dart';
import '../../models/priority.dart';
import '../../providers/task_provider.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? existing;
  const TaskFormScreen({super.key, this.existing});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _desc;

  PriorityLevel _priority = PriorityLevel.medium;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.existing?.title ?? '');
    _desc = TextEditingController(text: widget.existing?.description ?? '');
    _priority = widget.existing?.priority ?? PriorityLevel.medium;
    _dueDate = widget.existing?.dueDate ?? _dueDate;
    _completed = widget.existing?.isCompleted ?? false;
  }

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: _dueDate,
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  String _id() => DateTime.now().microsecondsSinceEpoch.toString();

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Task" : "Add Task")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(
                  labelText: "Title *",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? "Title is required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _desc,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Description (optional)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<PriorityLevel>(
                value: _priority,
                decoration: const InputDecoration(
                  labelText: "Priority",
                  border: OutlineInputBorder(),
                ),
                items: PriorityLevel.values
                    .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.label),
                ))
                    .toList(),
                onChanged: (v) => setState(() => _priority = v!),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Due Date"),
                subtitle: Text(
                  "${_dueDate.year}-${_dueDate.month}-${_dueDate.day}",
                ),
                trailing: ElevatedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.date_range),
                  label: const Text("Pick"),
                ),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _completed,
                onChanged: (v) => setState(() => _completed = v),
                title: const Text("Completed"),
              ),
              const SizedBox(height: 14),
              FilledButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final provider = context.read<TaskProvider>();

                  if (isEdit) {
                    final updated = widget.existing!.copyWith(
                      title: _title.text.trim(),
                      description: _desc.text.trim().isEmpty
                          ? null
                          : _desc.text.trim(),
                      priority: _priority,
                      dueDate: _dueDate,
                      isCompleted: _completed,
                    );
                    await provider.editTask(updated);
                  } else {
                    final task = Task(
                      id: _id(),
                      title: _title.text.trim(),
                      description: _desc.text.trim().isEmpty
                          ? null
                          : _desc.text.trim(),
                      priority: _priority,
                      dueDate: _dueDate,
                      isCompleted: _completed,
                      createdAt: DateTime.now(),
                    );
                    await provider.addTask(task);
                  }

                  if (context.mounted) Navigator.pop(context, true);
                },
                child: Text(isEdit ? "Save Changes" : "Create Task"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
