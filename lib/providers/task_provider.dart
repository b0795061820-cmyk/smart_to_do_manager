import 'package:flutter/foundation.dart';
import '../data/repositories/task_repository.dart';
import '../models/task.dart';
import '../models/priority.dart';


enum TaskFilter { all, completed, pending }

class TaskProvider extends ChangeNotifier {
  final TaskRepository _repo;

  TaskProvider(this._repo);

  List<Task> _tasks = [];
  String _search = "";
  TaskFilter _filter = TaskFilter.all;
  bool _sortByDueDate = false;

  List<Task> get tasks => _applyView(_tasks);

  TaskFilter get filter => _filter;
  bool get sortByDueDate => _sortByDueDate;

  Future<void> load() async {
    _tasks = _repo.getAll();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _repo.add(task);
    await load();
  }

  Future<void> editTask(Task task) async {
    await _repo.update(task);
    await load();
  }

  Future<void> removeTask(String id) async {
    await _repo.delete(id);
    await load();
  }

  Future<void> toggleStatus(Task task) async {
    final updated = task.copyWith(isCompleted: !task.isCompleted);
    await _repo.update(updated);
    await load();
  }

  void setSearch(String value) {
    _search = value.trim();
    notifyListeners();
  }

  void setFilter(TaskFilter value) {
    _filter = value;
    notifyListeners();
  }

  void toggleSort() {
    _sortByDueDate = !_sortByDueDate;
    notifyListeners();
  }

  List<Task> _applyView(List<Task> input) {
    Iterable<Task> out = input;

    if (_filter == TaskFilter.completed) {
      out = out.where((t) => t.isCompleted);
    } else if (_filter == TaskFilter.pending) {
      out = out.where((t) => !t.isCompleted);
    }

    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      out = out.where((t) =>
      t.title.toLowerCase().contains(q) ||
          (t.description ?? '').toLowerCase().contains(q));
    }

    final list = out.toList();

    if (_sortByDueDate) {
      list.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    } else {
      // default: priority high first, then due date
      list.sort((a, b) {
        final p = b.priority.weight.compareTo(a.priority.weight);
        if (p != 0) return p;
        return a.dueDate.compareTo(b.dueDate);
      });
    }

    return list;
  }
}
