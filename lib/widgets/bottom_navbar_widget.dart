import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/completed_tasks_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int navItemIndex = 0;

  void changeScreen(int newIndex) {
    if(newIndex == 1) {
      Navigator.of(context).push(
         CupertinoPageRoute(builder: (context) => const CompletedTasksScreen()),
      );
    } else {
      // Navigator.of(context).push(
      //   CupertinoPageRoute(builder: (context) => const AllTaskSScreen()),
      //);
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
            elevation: 0,
            backgroundColor: Colors.transparent,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            onTap: (index) => changeScreen(index),
            iconSize: 24,
            unselectedFontSize: 14,
            selectedFontSize: 16,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Setting',
                  tooltip: 'View Settings',
                  ),
            BottomNavigationBarItem(
                icon: Icon(Icons.done_all),
                label: 'Completed Task',
                tooltip: 'View all Completed Tasks',
              ),
            ],
          ),
        ),
    );
  }
}
