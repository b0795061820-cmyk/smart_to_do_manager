import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/task_provider.dart';
import '../widgets/task_tile.dart';
import '../widgets/filters_bar.dart';
import 'task_form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final tasks = provider.tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart To-Do Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () =>
                context.read<TaskProvider>().toggleSort(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => const TaskFormScreen(),
            ),
          );

          if (result == true && context.mounted) {
            context.read<TaskProvider>().load();
          }
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) =>
                  context.read<TaskProvider>().setSearch(value),
            ),
            const SizedBox(height: 10),
            const FiltersBar(),
            const SizedBox(height: 10),
            Expanded(
              child: tasks.isEmpty
                  ? const Center(child: Text('No tasks yet'))
                  : ListView.separated(
                itemCount: tasks.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 8),
                itemBuilder: (_, index) =>
                    TaskTile(task: tasks[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
