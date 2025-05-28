import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmate/main.dart';
import 'package:taskmate/models/alarm.module.dart';

@pragma('vm:entry-point')
void alarmCallback(int id) async {
  if (id == 0) {
    debugPrint('========================');
    debugPrint('====== INITIATED! ======');
    debugPrint('========================');
    return;
  }
  debugPrint('============================');
  debugPrint('====== Alarm $id triggered!======');
  debugPrint('============================');

  final prefs = await SharedPreferences.getInstance();
  final isSoundEnabled = prefs.getBool('soundEnabled') ?? true;

  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'alarm_channel_id',
        'Alarm Notifications',
        channelDescription: 'Channel for background alarm notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: isSoundEnabled,
        enableVibration: true,
        ticker: 'Alarm',
      );

  final NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  String? title;
  for (int i = -7; i <= 7; i++) {
    title = await Alarm.getAlarmTitleById(id + i);
    if (title != null) {
      debugPrint("Alarm title: $title found");
      break;
    } else {
      //
    }
  }

  await flutterLocalNotificationsPlugin.show(
    id,
    'ALARM',
    title,
    platformChannelSpecifics,
  );
}
