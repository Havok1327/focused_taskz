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


    List<Task> archivedTaskList =
        Provider.of<TaskProvider>(context).getArchivedTaskList;
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
              itemCount: archivedTaskList.length,
              itemBuilder: (_, index) => Dismissible(
                direction: DismissDirection.endToStart,
                key: ValueKey(
                  archivedTaskList[index],
                  ),
                onDismissed: (direction) {
                    Provider.of<TaskProvider>(context, listen: false)
                        .toActiveTask(
                        taskId: archivedTaskList[index].taskId,
                        archiveTask: archivedTaskList[index].taskName);
                  },
                background: Container(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                    Icon(Icons.restore, size: 22),
                    //Icon(Icons.restore, size: 22),
                    ]
                  ),
                ),
                child: ListTile(
                  tileColor: wholeColor,
                  contentPadding:
                      const EdgeInsets.only(left: 10, bottom: 0, top: 0),
                  hoverColor: Colors.green,
                  dense: true,
                  title: Text(
                    archivedTaskList[index].taskName,
                    style: kTaskNameStyle,
                  ),
                  subtitle: Text('Completed on ' + DateFormat('MM-dd-yyyy')
                    .format(archivedTaskList[index].completedOn),
                      style: kCompletedTaskDateStyle),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      Provider.of<TaskProvider>(context, listen: false)
                          .removeSingleTask(
                              id: archivedTaskList[index].taskId,
                              taskTitle: archivedTaskList[index].taskName);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.red,
        child: TextButton(
          onPressed: () {
            if (archivedTaskList.isNotEmpty) {
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
