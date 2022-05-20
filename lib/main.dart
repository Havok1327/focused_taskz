import 'dart:io';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:master_copy/constants/constants.dart';
import '../provider/task_provider.dart';
import '../screens/main_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'models/task.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //because we are going to do work before we run app we need to Init first
  final Directory dir =
      await getApplicationDocumentsDirectory(); //comes from path_provider
  final String path = dir.path;
  await Hive.initFlutter(path);
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  Hive.registerAdapter<Task>(TaskAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MaterialApp(
        builder: (context, widget) {
          return ResponsiveWrapper.builder(
            BouncingScrollWrapper.builder(context, widget!),
            defaultScale: true,
            breakpoints: [
              const ResponsiveBreakpoint.resize(600, name: MOBILE),
              const ResponsiveBreakpoint.autoScale(700, name: TABLET),
              const ResponsiveBreakpoint.resize(800, name: DESKTOP),
              const ResponsiveBreakpoint.autoScale(1700, name: "4k"),
            ],
          );
        },
        title: 'Focused Taskz',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          canvasColor: kDividerColor,
          primaryColor: kPrimaryColor,
        ),
        home: AnimatedSplashScreen(
          splash: SizedBox(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset(
                      'assets/images/list.png',
                  ),
                ),
                const Text(
                  'Focused Tasks',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 35,
                      letterSpacing: 2.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff212121)),
                )
              ],
            ),
          ),
          backgroundColor: const Color(0xffB3E5FC),
          nextScreen: const MainScreen(),
          splashTransition: SplashTransition.slideTransition,
          splashIconSize: 160,
        ),
      ),
    );
  }
}
