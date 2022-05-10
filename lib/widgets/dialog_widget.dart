import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../constants/constants.dart';
import '../models/task.dart';
import '../provider/task_provider.dart';

class DialogBox extends StatefulWidget {
  const DialogBox({Key? key, required this.context, this.passedTask, required this.index})
      : super(key: key);
  final BuildContext context;
  final Task? passedTask;
  final int? index;



  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  DateTime displayDate = DateTime.now();
  String newTask = '';
  bool validate = false;
  bool isImportant = false;
  bool isDatePicked = false;

  DateTime? initTaskId;
  String? initTaskName;
  DateTime? initCreatedDate;
  String? initDeadLineDate;
  DateTime? initCompletedOn;
  bool? initIsImportant;
  bool? initIsFinished;


  @override
  void initState() {
    initTaskId = widget.passedTask?.taskId;
    initTaskName = widget.passedTask?.taskName;
    initCreatedDate = widget.passedTask?.createdDate;
    initDeadLineDate = widget.passedTask?.deadlineDate;
    initCompletedOn = widget.passedTask?.completedOn;
    initIsImportant = widget.passedTask?.isImportant;
    initIsFinished = widget.passedTask?.isFinished;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    TaskProvider taskProvider = Provider.of<TaskProvider>(context, listen: false);
    return SimpleDialog(
      backgroundColor: Theme.of(context).canvasColor,
      contentPadding: const EdgeInsets.all(10),
      titlePadding: const EdgeInsets.all(10),
      title: Text(
        'Add Task',
        style: kAddTaskDialogStyle.copyWith(
          fontSize: 22,
          color: Theme.of(context).primaryColorDark,
        ),
        textAlign: TextAlign.center,
      ),
      children: [
        TextFormField(
        keyboardType: TextInputType.multiline,
          maxLines: null,
          initialValue: initTaskName,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Add a new task',
            fillColor: Colors.yellowAccent[100],
            filled: true,
            errorText: validate ? 'Field can\'t be empty' : null,
          ),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
          onChanged: (value) {
          String trimmedValue = value.trim();
          initTaskName = trimmedValue;
          },
    ),
        CheckboxListTile(
            contentPadding: const EdgeInsets.all(1),
            value: initIsImportant ?? isImportant,
            onChanged: (newValue) {
              if (newValue != null) {
                setState(() {
                  initIsImportant = newValue;
                  isImportant = newValue;
                });
              }
            },
          title: Text(
            'Focused Task',
            style: kAddTaskDialogStyle.copyWith(
              fontSize: 16,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (initTaskName != null) {
                      newTask = initTaskName!;
                    }
                    newTask.isEmpty ? validate = true : validate = false;
                    if (validate == false & newTask.isNotEmpty) {
                      if(widget.passedTask == null) {
                        final DateTime currentDate = DateTime.now();
                        final String currentTime =
                            DateFormat.jm().format(DateTime.now());
                        taskProvider.addNewTask(
                          creationDate: currentDate,
                          taskName: newTask,
                          deadlineDate: isDatePicked ? initDeadLineDate!
                              : taskProvider.stringOfSelectedDate,
                          isImportant: isImportant,
                        );
                      } else {
                        taskProvider.editTask(
                          taskId: widget.passedTask!.taskId,
                          editedTask: Task(
                            taskId: widget.passedTask!.taskId,
                            taskName: newTask,
                              completedOn: widget.passedTask!.completedOn,
                              createdDate: widget.passedTask!.createdDate,
                              deadlineDate: initDeadLineDate!,
                              isImportant: initIsImportant!,
                          ),
                        );
                      }
                      Navigator.of(context).pop();
                    }
                  });
                },
                child:const Icon(Icons.save),
            ),
          ],
        ),

      ],
    );
  }
}
