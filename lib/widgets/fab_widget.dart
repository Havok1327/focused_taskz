import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../widgets/dialog_widget.dart';

class FABWidget extends StatelessWidget {
  const FABWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: kPrimaryColor,
      splashColor: Colors.pinkAccent,
      foregroundColor: Colors.white,
      tooltip: 'Adds a new task',
      onPressed: () async {
        await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return DialogBox(context: context, index: 0);
          },
        );
      },
      child: const Icon(
        Icons.add_task,
        size: 34,
        color: Colors.white,
      ),
    );
  }
}
