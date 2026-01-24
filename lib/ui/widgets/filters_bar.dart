import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart';

class FiltersBar extends StatelessWidget {
  const FiltersBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();

    return Row(
      children: [
        ChoiceChip(
          label: const Text("All"),
          selected: provider.filter == TaskFilter.all,
          onSelected: (_) =>
              context.read<TaskProvider>().setFilter(TaskFilter.all),
        ),
        const SizedBox(width: 8),
        ChoiceChip(
          label: const Text("Pending"),
          selected: provider.filter == TaskFilter.pending,
          onSelected: (_) =>
              context.read<TaskProvider>().setFilter(TaskFilter.pending),
        ),
        const SizedBox(width: 8),
        ChoiceChip(
          label: const Text("Completed"),
          selected: provider.filter == TaskFilter.completed,
          onSelected: (_) =>
              context.read<TaskProvider>().setFilter(TaskFilter.completed),
        ),
      ],
    );
  }
}
