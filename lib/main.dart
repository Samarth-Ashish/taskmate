import 'dart:io';
import 'dart:isolate';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:taskmate/callbacks/alarm_callback.dart';
import 'package:taskmate/models/alarm.module.dart';
import 'package:taskmate/pages/default_page.dart';
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> requestNotificationsPermission() async {
  // Initialize plugin if not already done
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Only required on Android 13+ (API level 33+)
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestNotificationsPermission();

  // Init local notifications
  // const AndroidInitializationSettings initializationSettingsAndroid =
  //     AndroidInitializationSettings('@mipmap/ic_launcher');

  // const InitializationSettings initializationSettings = InitializationSettings(
  //   android: initializationSettingsAndroid,
  // );

  // await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // tz.initializeTimeZones();
  // await Alarm.init();

  // Init alarm manager
  await AndroidAlarmManager.initialize();
  // await AndroidAlarmManager.cancel(0);
  await AlarmModel.syncAlarmsWithSystem();

  runApp(MyApp());
  //
  // debugPrint('======Alarm initialized!======');
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: DefaultNavPage(),
    );
  }
}
