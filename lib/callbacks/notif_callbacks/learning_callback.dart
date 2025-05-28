import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmate/main.dart';
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
  debugPrint('====== Subject $id triggered!======');
  debugPrint('============================');

  final prefs = await SharedPreferences.getInstance();
  final isSoundEnabled = prefs.getBool('soundEnabled') ?? true;

  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'study_channel_id',
        'Study Notifications',
        channelDescription: 'Channel for background study notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: isSoundEnabled,
        enableVibration: true,
        ticker: 'Study Session',
      );

  final NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  String? title;
  for (int i = -7; i <= 7; i++) {
    title = await Subject.getSubjectTitleById(id + i);
    if (title != null) {
      debugPrint("Subject title: $title found");
      break;
    } else {
      //
    }
  }

  await flutterLocalNotificationsPlugin.show(
    id,
    'STUDY SESSION REMINDER',
    title,
    platformChannelSpecifics,
  );
}
