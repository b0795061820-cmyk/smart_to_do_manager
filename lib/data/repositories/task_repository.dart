import '../../models/task.dart';
import '../local/hive_service.dart';

class TaskRepository {
  final _box = HiveService.tasksBox();

  List<Task> getAll() {
    final tasks = _box.values.toList();
    tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return tasks;
  }

  Future<void> add(Task task) async {
    await _box.put(task.id, task);
  }

  Future<void> update(Task task) async {
    await _box.put(task.id, task);
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}
