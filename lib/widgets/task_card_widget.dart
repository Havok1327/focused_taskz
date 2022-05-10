import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../constants/constants.dart';
import 'package:path_provider/path_provider.dart';
import '../models/task.dart';
import '../provider/task_provider.dart';
import 'dialog_widget.dart';

class TaskCard extends StatelessWidget {
  TaskCard({
    Key? key,
    required this.cardName,
    required this.cardSideColor,
    required this.isImp,
    required this.cardMaxColor,
    required this.placeholderWidget,
  }) : super(key: key);

  final Color cardSideColor;
  final Color cardMaxColor;
  final String cardName;
  final bool isImp;
  final Widget placeholderWidget;

  List<Task> finalTaskList = [];
  String? selectedDate;
  double percentValue = 0.05;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TaskProvider>(context, listen: true);
    finalTaskList =
        isImp ? provider.getPriorityList : provider.getOtherTaskList;
    percentValue = provider.currentFinishedTaskCount(finalTaskList) /
        provider.currentTotalTaskCount(finalTaskList);
    return Card(
      color: cardMaxColor,
      margin: kCardMargin,
      elevation: 4,
      shadowColor: const Color(0xffd1faff),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: LinearPercentIndicator(
                  animation: true,
                  animateFromLastPercent: true,
                  backgroundColor: cardSideColor.withOpacity(0.4),
                  progressColor: cardSideColor,
                  barRadius: const Radius.circular(30),
                  percent: percentValue.isNaN ? 0.00 : percentValue,
                  lineHeight: 22,
                  center: Text(
                    cardName,
                    style: kProgressStyle,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
              child: finalTaskList.isEmpty
                  ? Center(child: placeholderWidget)
                  : Consumer<TaskProvider>(
                builder: (context, TaskProvider taskProvider, child) {
                  finalTaskList = isImp
                      ? taskProvider.getPriorityList
                      : taskProvider.getOtherTaskList;
                  return ListView.separated(
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 1,
                        thickness: 1.5,
                        indent: 14,
                          endIndent: 14,
                        color: cardSideColor.withOpacity(0.1),
                      );
                    },
                    itemCount: finalTaskList.length,
                    itemBuilder: (_, index) => Dismissible(
                      key: ValueKey(
                        finalTaskList[index],
                        ),
                      onDismissed: (direction) {
                        taskProvider.removeSingleTask(
                          id: finalTaskList[index].taskId,
                          taskTitle: finalTaskList[index].taskName,
                        );
                      },
                      background: Container(
                        padding: const EdgeInsets.only(right: 20, left: 20),
                        decoration: BoxDecoration(
                          color: Colors.redAccent[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Icon(Icons.delete, size: 22),
                            Icon(Icons.delete, size: 22),
                          ],
                        ),
                      ),
                      child: ListTile(
                        key: ValueKey(
                          finalTaskList[index],
                        ),
                        minVerticalPadding: 0,
                        contentPadding: const EdgeInsets.only(
                          top: 0,
                          right: 0,
                          left: 6,
                          bottom: 0,
                        ),
                        iconColor: Theme.of(context).primaryColorDark,
                        horizontalTitleGap: 15,
                        leading: InkWell(
                          splashColor: Colors.pink,
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (_) => DialogBox(
                                  context: _,
                                  passedTask: finalTaskList[index],
                                  index: index,
                                ),
                            );
                          },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(4),
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorLight,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: cardMaxColor,
                              width: 4,
                            )
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              finalTaskList[index].taskName[0].toUpperCase(),
                              //finalTaskList[index].deadlineDate,
                              style: kDisplayTimeStyle,
                              softWrap: true,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        ),
                        textColor: cardSideColor,
                        title: InkWell(
                          splashColor: cardMaxColor,
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (_) => DialogBox(
                              context: _,
                                passedTask: finalTaskList[index],
                              index: index,
                            ),
                            );
                          },
                          child: Text(
                            finalTaskList[index].taskName,
                            style: kTaskNameStyle.copyWith(
                              decorationColor: cardSideColor,
                              decorationThickness: 2,
                              decoration: finalTaskList[index].isFinished
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            ),
                          ),
                        ),
                        trailing: Checkbox(
                          value: finalTaskList[index].isFinished,
                          activeColor: cardSideColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)
                          ),
                          side: BorderSide(
                            color: cardSideColor,
                          ),
                          onChanged: (newValue) {
                            taskProvider.toggleTask(
                              taskId: finalTaskList[index].taskId,
                              taskName: finalTaskList[index].taskName,
                              completedOnDate: DateTime.now(),
                              newValue: newValue ?? false,
                            );
                          },
                        )
                      ),
                    ),
                  );

                },
              ),

          ),
        ],
      ),
    );
  }
}
