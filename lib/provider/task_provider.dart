import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  static const boxName = 'tasksBox';

  List<Task> _taskList = [];
  List<Task> _sortedTasksByDate = [];
  String stringOfSelectedDate = '';
  DateTime objectOfSelectedDate = DateTime.now();

  void getAllTasks() async {
    var box = await Hive.openBox<Task>(boxName);
    _taskList = box.values.toList();
    notifyListeners();
  }

  List<Task> get getPriorityList {
    List<Task> newPriorityList =
        _sortedTasksByDate
            .where(
                (item) => item.isImportant == true && item.isArchived == false)
            .toList();
    return [...newPriorityList];
  }

  List<Task> get getOtherTaskList {
    return [
      ..._sortedTasksByDate
          .where(
              (task) => task.isImportant == false && task.isArchived == false)
          .toList()
    ];
  }

  int currentTotalTaskCount(List<Task> taskList) {
    return taskList.length;
  }

  int currentFinishedTaskCount(List<Task> taskList) {
    List<Task> newList =
        taskList.where((task) => task.isFinished == true).toList();
    return newList.length;
  }

  void removeSingleTask(
      {required DateTime id, required String taskTitle}) async {
    var box = await Hive.openBox<Task>(boxName);
    _taskList = box.values.toList();
    Task toDeleteTask = _taskList
        .firstWhere((task) => task.taskId == id && task.taskName == taskTitle);
    int toDeleteItemIndex = _taskList.indexOf(toDeleteTask);
    await box.deleteAt(toDeleteItemIndex);

    _taskList = box.values.toList();
    notifyListeners();
  }

  void addNewTask(
      {required DateTime creationDate,
      required String deadlineDate,
      required String taskName,
      required bool isImportant}) async {
    var box = await Hive.openBox<Task>(boxName);
    await box.add(
      Task(
        taskId: DateTime.now(),
        taskName: taskName,
        createdDate: creationDate,
        deadlineDate: deadlineDate,
        completedOn: DateTime.now(),
        isImportant: isImportant,
      ),
    );
    _taskList = box.values.toList();

    notifyListeners();
  }

  void editTask({required DateTime taskId, required Task editedTask}) async {
    var box = await Hive.openBox<Task>(boxName);
    _taskList = box.values.toList();
    Task toEditTask = _taskList.firstWhere((task) => task.taskId == taskId);
    int editItemIndex = _taskList.indexOf(toEditTask);

    await box.putAt(editItemIndex, editedTask);
    _taskList = box.values.toList();

    notifyListeners();
  }

  void toggleTask(
      {required DateTime taskId,
      required String taskName,
      required DateTime completedOnDate,
      required bool newValue}) async {
    var box = await Hive.openBox<Task>(boxName);
    _taskList = box.values.toList();
    Task toModifyTask = _taskList.firstWhere(
      (item) => item.taskId == taskId && item.taskName == taskName,
    );
    toModifyTask.isFinished = newValue;
    toModifyTask.completedOn = completedOnDate;

    int toModifyTaskIndex = _taskList.indexOf(toModifyTask);
    await box.putAt(toModifyTaskIndex, toModifyTask);
    _taskList = box.values.toList();

    notifyListeners();
  }

  void sortTaskByDate(DateTime date) async {
    objectOfSelectedDate = date;
    stringOfSelectedDate = DateFormat('MM-dd-yyyy').format(date);
    var box = await Hive.openBox<Task>(boxName);
    _sortedTasksByDate = box.values.toList();
    _taskList = box.values.toList();

    notifyListeners();
  }

  List<Task> get getArchivedTaskList {
    List<Task> completedTasks = _taskList
        .where((task) => task.isArchived == true)
        .toList();
    return [...completedTasks];
  }

  void deleteAllArchivedTasks() async {
    var box = await Hive.openBox<Task>(boxName);
    _taskList = box.values.toList();
    List<Task> toDeleteTasks = box.values
        .where((task) => task.isFinished == true || task.isArchived == true)
        .toList();

    for (Task task in toDeleteTasks) {
      if (toDeleteTasks.isNotEmpty) {
        await box.deleteAt(_taskList.indexOf(task));
        _taskList = box.values.toList();
      } else {
        return;
      }
    }
    _taskList = box.values.toList();
    notifyListeners();
  }

  void toArchiveTask(
      {required DateTime taskId, required String archiveTask}) async {
    var box = await Hive.openBox<Task>(boxName);
    _taskList = box.values.toList();
    Task toArchiveTask = _taskList.firstWhere((task) => task.taskId == taskId);

    toArchiveTask.isArchived = true;

    int toModifyTaskIndex = _taskList.indexOf(toArchiveTask);
    await box.putAt(toModifyTaskIndex, toArchiveTask);
    _taskList = box.values.toList();

    notifyListeners();
  }

  void toActiveTask(
      {required DateTime taskId, required String archiveTask}) async {
    var box = await Hive.openBox<Task>(boxName);
    _taskList = box.values.toList();
    Task toArchiveTask = _taskList.firstWhere((task) => task.taskId == taskId);

    toArchiveTask.isArchived = false;

    int toModifyTaskIndex = _taskList.indexOf(toArchiveTask);
    await box.putAt(toModifyTaskIndex, toArchiveTask);
    _taskList = box.values.toList();

    notifyListeners();
  }
}
