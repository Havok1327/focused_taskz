import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../screens/archived_tasks_screen.dart';
import '../screens/settings_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int navItemIndex = 0;

  void changeScreen(int newIndex) {
    if (newIndex == 1) {
      Navigator.of(context).push(
        CupertinoPageRoute(builder: (context) => const ArchivedTasksScreen()),
      );
    } else {
      //showDialog(
        // context: context,
        // builder: (_) => AlertDialog(
        //   backgroundColor: Theme.of(context).canvasColor,
        //   content: const Text('Not yet implemented.'),
        //   actions: [
        //     TextButton(
        //       onPressed: () {
        //         Navigator.of(context).pop();
        //       },
        //       child: const Text('OK'),
        //     ),
        //   ],
        // ),
      //);
      Navigator.of(context).push(
        CupertinoPageRoute(builder: (context) => const SettingsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        color: Theme.of(context).primaryColor,
        elevation: 0,
        child: BottomNavigationBar(
          currentIndex: 1,
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedItemColor: kLightPrimaryColor,
          unselectedItemColor: kLightPrimaryColor,
          onTap: (index) => changeScreen(index),
          iconSize: 25,
          unselectedFontSize: 14,
          selectedFontSize: 15,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Setting',
              tooltip: 'View Settings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.archive),
              label: 'Archived Task',
              tooltip: 'View all Archived Tasks',
            ),
          ],
        ),
      ),
    );
  }
}