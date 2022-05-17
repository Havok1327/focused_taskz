import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

//

part 'task.g.dart';

@HiveType(typeId: 0)
class Task {

  @HiveField(0)
  final DateTime taskId;

  @HiveField(1)
  final String taskName;

  @HiveField(2)
  final DateTime createdDate;

  @HiveField(3)
  final String deadlineDate;

  @HiveField(4)
  DateTime completedOn;

  @HiveField(5)
  final bool isImportant;

  @HiveField(6)
  bool isFinished;

  @HiveField(7)
  bool isArchived;

  Task({
    required this.taskId,
    required this.taskName,
    required this.createdDate,
    required this.deadlineDate,
    required this.completedOn,
    this.isImportant = false,
    this.isFinished = false,
    this.isArchived = false,
  });
}