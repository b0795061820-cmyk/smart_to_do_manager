import 'package:hive_flutter/hive_flutter.dart';
import '../../models/task.dart';
import '../../models/priority_adapter.dart';

class HiveService {
  static const String tasksBoxName = 'tasks_box';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters (مرة واحدة فقط)
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TaskAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(PriorityLevelAdapter());
    }

    await Hive.openBox<Task>(tasksBoxName);
  }

  static Box<Task> tasksBox() {
    return Hive.box<Task>(tasksBoxName);
  }
}
