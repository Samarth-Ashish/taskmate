import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
  debugPrint('======Alarm $id triggered!======');
  debugPrint('============================');

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'alarm_channel_id',
        'Alarm Notifications',
        channelDescription: 'Channel for background alarm notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        ticker: 'Alarm',
      );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  String? title;
  for (int i = -7; i <= 7; i++) {
    title = await Alarm.getAlarmTitleById(id + i);
    if (title != null) {
      debugPrint("Alarm title: $title found");
      break;
    } else {
      // debugPrint("No alarm found for the given ID");
    }
  }

  await flutterLocalNotificationsPlugin.show(
    id,
    'Alarm : $title',
    title,
    platformChannelSpecifics,
  );
}
