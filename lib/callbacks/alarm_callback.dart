import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:taskmate/main.dart';
import 'package:taskmate/models/alarm.module.dart';

@pragma('vm:entry-point')
void alarmCallback(int id) async {
  if (id == 0) {
    debugPrint('====== INITIATED! ======');
    return;
  }

  debugPrint('======Alarm triggered!======');
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'alarm_channel_id',
        'Alarm Notifications',
        channelDescription: 'Channel for background alarm notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        ticker: 'Reminder',
      );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  String? title = await AlarmModel.getAlarmTitleById(id);
  if (title != null) {
    debugPrint("Alarm title: $title found");
  } else {
    debugPrint("No alarm found for the given ID");
  }

  await flutterLocalNotificationsPlugin.show(
    id,
    'Alarm : $title',
    title,
    platformChannelSpecifics,
  );
}
