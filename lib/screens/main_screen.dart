import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';
import '../provider/task_provider.dart';
import 'package:intl/intl.dart';
import '../widgets/bottom_navbar_widget.dart';
import '../widgets/fab_widget.dart';
import '../widgets/task_card_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String formattedDate = DateFormat('MM/dd/yyyy').format(DateTime.now());
  String formattedTime = DateFormat.Hm().format(DateTime.now());
  TimeOfDay? distime;
  var finalTime;
  DateTime? disDate;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TaskProvider>(context, listen: false);
    provider.getAllTasks();
    //setState(() {
    provider.sortTaskByDate(DateTime.now());
    //});
    //provider.sortTaskByDate(DateTime.now());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const FABWidget(),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            child: AppBar(
              backgroundColor: Colors.blue,
              title: const Center(
                  child: Text(
                'Focused Taskz',
                style: TextStyle(
                  fontSize: 23.0,
                  fontWeight: FontWeight.w900,
                  color: Color(0xffffd900),
                ),
              )),
            ),
            height: MediaQuery.of(context).size.height * 0.08,
            width: double.infinity,
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 1),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 140,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 3,
                    child: TaskCard(
                      cardName: 'Focused Tasks',
                      cardMaxColor: Colors.lime[50]!,
                      cardSideColor: const Color(0xffee4266),
                      isImp: true,
                      placeholderWidget: Column(),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: TaskCard(
                      cardName: 'Parked Tasks',
                      cardMaxColor: Colors.lime[50]!,
                      cardSideColor: const Color(0xff0b3866),
                      isImp: false,
                      placeholderWidget: Column(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
