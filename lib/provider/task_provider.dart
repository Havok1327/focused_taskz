import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  static const boxName = 'tasksBox';

  List<Task> _taskList = [];

  void getAllTasks() async {
    var box = await Hive.openBox<Task>(boxName);
    _taskList = box.values.toList();
    notifyListeners();
}

}