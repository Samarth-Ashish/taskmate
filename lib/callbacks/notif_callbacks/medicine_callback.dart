import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  debugPrint('====== Medicine $id triggered!======');
  debugPrint('============================');

  final prefs = await SharedPreferences.getInstance();
  final isSoundEnabled = prefs.getBool('soundEnabled') ?? true;

  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'medicine_channel_id',
        'Medical Notifications',
        channelDescription: 'Channel for background medical notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: isSoundEnabled,
        enableVibration: true,
        ticker: 'Medicine',
      );

  final NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  String? title;
  String? quantity;
  for (int i = -7; i <= 7; i++) {
    title = await Medicine.getMedicineTitleById(id + i);
    quantity = await Medicine.getMedicineQuantityById(id + i);
    if (title != null && quantity != null) {
      debugPrint("Medicine title: $title found");
      break;
    } else {
      //
    }
  }

  await flutterLocalNotificationsPlugin.show(
    id,
    'MEDICINE REMINDER',
    '$title ($quantity)',
    platformChannelSpecifics,
  );
}
