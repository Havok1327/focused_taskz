import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/task_provider.dart';
import '../constants/constants.dart';
import '../models/task.dart';
import 'package:intl/intl.dart';

class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({Key? key}) : super(key: key);
  //static const routeName = 'completed_task-screen';

  @override
  Widget build(BuildContext context) {
    final Color wholeColor = Colors.yellow[50]!;

    List<Task> completedTaskList =
        Provider.of<TaskProvider>(context).getCompletedTaskList;
    return Scaffold(
      backgroundColor: wholeColor,
      appBar: AppBar(
        title: const Text('All Archived Tasks'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return Divider(
                  height: 1,
                  endIndent: 10,
                  indent: 10,
                  thickness: 1,
                  color: Theme.of(context).primaryColor,
                );
              },
              itemCount: completedTaskList.length,
              itemBuilder: (_, index) {
                String taskCompletedOn = DateFormat('MM-dd-yyyy')
                    .format(completedTaskList[index].completedOn);
                return ListTile(
                  tileColor: wholeColor,
                  contentPadding:
                      const EdgeInsets.only(left: 10, bottom: 0, top: 0),
                  hoverColor: Colors.green,
                  dense: true,
                  title: Text(
                    completedTaskList[index].taskName,
                    style: kTaskNameStyle,
                  ),
                  subtitle: Text('Completed on $taskCompletedOn',
                      style: kCompletedTaskDateStyle),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      Provider.of<TaskProvider>(context, listen: false)
                          .removeSingleTask(
                              id: completedTaskList[index].taskId,
                              taskTitle: completedTaskList[index].taskName);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.red,
        child: TextButton(
          onPressed: () {
            if (completedTaskList.isNotEmpty) {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: Theme.of(context).canvasColor,
                  content: const Text('Delete All Completed Tasks?'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('NO')),
                    TextButton(
                      onPressed: () {
                        Provider.of<TaskProvider>(context, listen: false)
                            .deleteAllCompletedTasks();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              );
            } else {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text(
                      'No New Task Completed!',
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
            }
          },
          child: const Text(
            'Clear All',
            style: kDeleteAllTextStyle,
          ),
        ),
      ),
    );
  }
}
