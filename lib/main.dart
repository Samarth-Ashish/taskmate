import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:taskmate/notif_callbacks/alarm_callback.dart';
import 'package:taskmate/models/alarm.module.dart';
import 'package:taskmate/models/medicine.module.dart';
import 'package:taskmate/pages/navigation_page.dart';
import 'package:taskmate/pages/splash_screen.dart';
import 'package:taskmate/utils/snackbar_utils.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> requestNotificationsPermission() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  if (Platform.isAndroid) {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    final bool? granted = await androidImplementation
        ?.requestNotificationsPermission();

    if (granted != null && granted) {
      debugPrint('✅ Notification permission granted.');
    } else {
      debugPrint('❌ Notification permission denied.');
    }
  }
}

Future<bool> isIgnoringBatteryOptimizations() async {
  const platform = MethodChannel("battery_optimization");
  try {
    final bool result = await platform.invokeMethod(
      "isIgnoringBatteryOptimizations",
    );
    return result;
  } on PlatformException catch (e) {
    debugPrint("Error checking battery optimization: $e");
    return false;
  }
}

Future<void> requestBatteryOptimizationExemption() async {
  const platform = MethodChannel("battery_optimization");
  final isIgnoring = await platform.invokeMethod<bool>(
    'isIgnoringBatteryOptimizations',
  );
  if (isIgnoring == false) {
    await platform.invokeMethod('requestIgnoreBatteryOptimizations');
  }
}

//!
//!
//!
//!

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Request permissions
  await requestNotificationsPermission();
  await requestBatteryOptimizationExemption();

  // Init alarm manager
  await AndroidAlarmManager.initialize();
  await Alarm.syncAlarmsWithSystem();
  await Medicine.syncMedicinesWithSystem();

  runApp(MyApp());
  //!
  try {
    await AndroidAlarmManager.oneShot(
      Duration(minutes: 1),
      0,
      alarmCallback,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
    debugPrint('Alarm set successfully!');
  } catch (e) {
    debugPrint('Alarm set failed: $e');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskMate',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: SnackbarUtil.scaffoldMessengerKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: DefaultNavPage(),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashPage(),
        '/home': (context) => DefaultNavPage(),
      },
    );
  }
}
