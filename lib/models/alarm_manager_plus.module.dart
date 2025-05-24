// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
// import 'package:taskmate/models/alarm.module.dart';

// class AlarmHelper {
//   static const String _key = 'alarms';

//   /// Save a list of alarms to SharedPreferences
//   static Future<void> saveAlarms(List<AlarmModel> alarms) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final alarmListJson = alarms.map((alarm) => alarm.toJson()).toList();
//     await prefs.setString(_key, jsonEncode(alarmListJson));
//   }

//   /// Load alarms from SharedPreferences
//   static Future<List<AlarmModel>> loadAlarms() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final jsonString = prefs.getString(_key);
//     if (jsonString == null) return [];

//     final List<dynamic> jsonList = jsonDecode(jsonString);
//     return jsonList.map((json) => AlarmModel.fromJson(json)).toList();
//   }

//   /// Add a new alarm
//   static Future<void> addAlarm(AlarmModel alarm) async {
//     final alarms = await loadAlarms();
//     alarms.add(alarm);
//     await saveAlarms(alarms);
//   }

//   /// Remove an alarm by ID
//   static Future<void> removeAlarm(int id) async {
//     final alarms = await loadAlarms();
//     alarms.removeWhere((alarm) => alarm.id == id);
//     await saveAlarms(alarms);
//   }

//   /// Schedule all alarms
//   static Future<void> scheduleAllAlarms() async {
//     final alarms = await loadAlarms();
//     for (final alarm in alarms) {
//       if (alarm.isEnabled ?? true && alarm.alarmTime != null) {
//         await _scheduleAlarm(alarm);
//       }
//     }
//   }

//   /// Register a specific alarm using android_alarm_manager_plus
//   static Future<void> _scheduleAlarm(AlarmModel alarm) async {
//     final now = DateTime.now();
//     final time = alarm.alarmTime!;
//     DateTime alarmDateTime = DateTime(
//       now.year,
//       now.month,
//       now.day,
//       time.hour,
//       time.minute,
//     );
//     if (alarmDateTime.isBefore(now)) {
//       alarmDateTime = alarmDateTime.add(const Duration(days: 1));
//     }

//     await AndroidAlarmManager.oneShotAt(
//       alarmDateTime,
//       alarm.id!,
//       _alarmCallback,
//       exact: true,
//       wakeup: true,
//     );
//   }

//   /// Callback for the alarm trigger
//   static void _alarmCallback() {
//     print('⏰ AlarmModel Triggered!');
//     // Add logic to show a notification or execute any action here
//   }
// }
