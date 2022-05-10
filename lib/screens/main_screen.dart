import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';
import '../provider/task_provider.dart';
import 'package:intl/intl.dart';
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const FABWidget(),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.18,
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
              height: MediaQuery.of(context).size.height - 120,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 3,
                    child: TaskCard(
                      cardName: 'Focused Tasks',
                      cardSideColor: const Color(0xffee4266),
                      cardMaxColor: Colors.lime[50]!,
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
