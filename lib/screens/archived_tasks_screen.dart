import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/task_provider.dart';
import '../constants/constants.dart';
import '../models/task.dart';
import 'package:intl/intl.dart';

class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color wholeColor = kLightPrimaryColor;

    List<Task> archivedTaskList =
        Provider.of<TaskProvider>(context).getArchivedTaskList;
    return Scaffold(
      backgroundColor: wholeColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: kLightPrimaryColor),
        title: const Text(
          'All Archived Tasks',
          style: TextStyle(
            fontSize: 23.0,
            fontWeight: FontWeight.w600,
            color: kLightPrimaryColor,
          ),
        ),
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
                      ]),
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
                  subtitle: Text(
                      'Completed on ' +
                          DateFormat('MM-dd-yyyy')
                              .format(archivedTaskList[index].completedOn),
                      style: kCompletedTaskDateStyle),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.redAccent,
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
        color: kPrimaryColor,
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
                            .deleteAllArchivedTasks();
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
                      'No Archived Tasks!',
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
