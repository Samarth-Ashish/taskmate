import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:taskmate/main.dart';
import 'package:taskmate/models/alarm.module.dart';
import 'package:taskmate/models/learning.module.dart';

@pragma('vm:entry-point')
void studySessionCallback(int id) async {
  if (id == 0) {
    debugPrint('========================');
    debugPrint('====== INITIATED! ======');
    debugPrint('========================');
    return;
  }
  debugPrint('============================');
  debugPrint('======Alarm triggered!======');
  debugPrint('============================');

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'study_channel_id',
        'Study Notifications',
        channelDescription: 'Channel for background study notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        ticker: 'Study Session',
      );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  String? title;
  for (int i = -7; i <= 7; i++) {
    title = await Subject.getSubjectTitleById(id + i);
    if (title != null) {
      debugPrint("Subject title: $title found");
      break;
    } else {
      // debugPrint("No subject found for the given ID");
    }
  }

  await flutterLocalNotificationsPlugin.show(
    id,
    'Study Session : $title',
    title,
    platformChannelSpecifics,
  );
}
