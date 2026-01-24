import 'package:hive/hive.dart';
import 'priority.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  PriorityLevel priority;

  @HiveField(4)
  DateTime dueDate;

  @HiveField(5)
  bool isCompleted;

  @HiveField(6)
  DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.priority,
    required this.dueDate,
    required this.isCompleted,
    required this.createdAt,
  });

  Task copyWith({
    String? title,
    String? description,
    PriorityLevel? priority,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
    );
  }
}
