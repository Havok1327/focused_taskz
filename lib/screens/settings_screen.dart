import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/task_provider.dart';
import '../constants/constants.dart';
import '../models/task.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color wholeColor = kLightPrimaryColor;

    //Code is unused I wanted to pull the version from pubspec but didn't have time.
    Future<void> _initPackageInfo() async {
      final info = await PackageInfo.fromPlatform();
      String appName = info.appName;
      String packageName = info.packageName;
      String version = info.version;
      String buildNumber = info.buildNumber;
    }

    List<Task> archivedTaskList =
        Provider.of<TaskProvider>(context).getArchivedTaskList;
    return Scaffold(
      backgroundColor: wholeColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: kLightPrimaryColor),
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 23.0,
            fontWeight: FontWeight.w600,
            color: kLightPrimaryColor,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(
                top: 30.0, left: 10.0, right: 30.0, bottom: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text(
                  'Focused Tasked Version: 1.1.2 \n \nThanks for downloading. \nPlease provide feedback: '
                  '\nblunderingblogger@gmail.com',
                  style: kSettingStyle,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: kPrimaryColor,
        child: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Return',
            style: kDeleteAllTextStyle,
          ),
        ),
      ),
    );
  }
}
