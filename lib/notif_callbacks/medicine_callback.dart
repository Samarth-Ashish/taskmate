import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:taskmate/main.dart';
import 'package:taskmate/models/medicine.module.dart';

@pragma('vm:entry-point')
void medicineCallback(int id) async {
  if (id == 0) {
    debugPrint('========================');
    debugPrint('====== INITIATED! ======');
    debugPrint('========================');
    return;
  }
  debugPrint('============================');
  debugPrint('======Medicine triggered!======');
  debugPrint('============================');

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'medicine_channel_id',
        'Medical Notifications',
        channelDescription: 'Channel for background medical notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        ticker: 'Medicine',
      );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  String? title;
  for (int i = -7; i <= 7; i++) {
    title = await Medicine.getMedicineTitleById(id + i);
    if (title != null) {
      debugPrint("Alarm title: $title found");
      break;
    } else {
      // debugPrint("No alarm found for the given ID");
    }
  }

  await flutterLocalNotificationsPlugin.show(
    id,
    'Medicine Reminder : $title',
    title,
    platformChannelSpecifics,
  );
}
