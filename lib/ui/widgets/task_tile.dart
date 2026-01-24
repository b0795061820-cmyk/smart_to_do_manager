import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/task.dart';
import '../../models/priority.dart';
import '../../providers/task_provider.dart';
import '../screens/task_form_screen.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<TaskProvider>();
    final due =
        "${task.dueDate.year}-${task.dueDate.month}-${task.dueDate.day}";

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: task.isCompleted,
              onChanged: (_) => provider.toggleStatus(task),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  if ((task.description ?? '').trim().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      task.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(
                        label:
                        Text("Priority: ${task.priority.label}"),
                      ),
                      Chip(label: Text("Due: $due")),
                      Chip(
                        label: Text(
                          task.isCompleted ? "Completed" : "Pending",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == "edit") {
                  final changed = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          TaskFormScreen(existing: task),
                    ),
                  );
                  if (changed == true && context.mounted) {
                    provider.load();
                  }
                } else if (value == "delete") {
                  await provider.removeTask(task.id);
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: "edit",
                  child: Text("Edit"),
                ),
                PopupMenuItem(
                  value: "delete",
                  child: Text("Delete"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
