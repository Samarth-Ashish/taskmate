import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/alarm.module.dart';

class AlarmController {
  static final AlarmController _instance = AlarmController._internal();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final List<Alarm> _alarms = [];
  static const String _alarmsKey = 'alarms';

  factory AlarmController() => _instance;

  AlarmController._internal() {
    _initNotifications();
    _loadAlarms();
  }

  List<Alarm> get alarms => List.unmodifiable(_alarms);

  Future<void> _initNotifications() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap
      },
    );
  }

  Future<void> _loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final String? alarmsString = prefs.getString(_alarmsKey);

    if (alarmsString != null && alarmsString.isNotEmpty) {
      try {
        final List<dynamic> jsonList = jsonDecode(alarmsString);
        _alarms.clear();
        for (var json in jsonList) {
          _alarms.add(Alarm.fromJson(json));
        }

        // Reschedule all active alarms
        for (var alarm in _alarms) {
          if (alarm.isEnabled == true) {
            await _scheduleAlarm(alarm);
          }
        }
      } catch (e) {
        debugPrint('Error loading alarms: $e');
        _alarms.clear();
      }
    }
  }

  Future<void> _saveAlarms() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _alarms.map((alarm) => alarm.toJson()).toList();
      await prefs.setString(_alarmsKey, jsonEncode(jsonList));
    } catch (e) {
      debugPrint('Error saving alarms: $e');
    }
  }

  Future<void> addAlarm(Alarm alarm) async {
    try {
      alarm.id ??= DateTime.now().millisecondsSinceEpoch;
      // Ensure default values
      alarm.isEnabled ??= true;
      _alarms.add(alarm);
      await _saveAlarms();
      if (alarm.isEnabled == true) {
        await _scheduleAlarm(alarm);
      }
    } catch (e) {
      debugPrint('Error adding alarm: $e');
      rethrow;
    }
  }

  Future<void> updateAlarm(Alarm updatedAlarm) async {
    try {
      final index = _alarms.indexWhere((alarm) => alarm.id == updatedAlarm.id);
      if (index != -1) {
        // Preserve ID if not set
        updatedAlarm.id ??= _alarms[index].id;
        _alarms[index] = updatedAlarm;
        await _saveAlarms();
        await _cancelScheduledAlarm(updatedAlarm.id!);
        if (updatedAlarm.isEnabled == true) {
          await _scheduleAlarm(updatedAlarm);
        }
      }
    } catch (e) {
      debugPrint('Error updating alarm: $e');
      rethrow;
    }
  }

  Future<void> deleteAlarm(int id) async {
    try {
      await _cancelScheduledAlarm(id);
      _alarms.removeWhere((alarm) => alarm.id == id);
      await _saveAlarms();
    } catch (e) {
      debugPrint('Error deleting alarm: $e');
      rethrow;
    }
  }

  Future<void> toggleAlarm(int id, bool isEnabled) async {
    final alarm = _alarms.firstWhere((alarm) => alarm.id == id);
    alarm.isEnabled = isEnabled;

    if (isEnabled) {
      await _scheduleAlarm(alarm);
    } else {
      await _cancelScheduledAlarm(id);
    }

    await _saveAlarms();
  }

  Future<void> _scheduleAlarm(Alarm alarm) async {
    try {
      if (alarm.alarmTime == null || alarm.isEnabled != true) return;

      final now = DateTime.now();
      var scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        alarm.alarmTime!.hour,
        alarm.alarmTime!.minute,
      );

      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
      }

      final tz.TZDateTime scheduledTZ = tz.TZDateTime.from(
        scheduledTime,
        tz.local,
      );

      final androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'alarm_channel',
        'Alarm Notifications',
        channelDescription: 'Alarm notifications',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
      );

      final platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        alarm.id!,
        'Alarm: ${alarm.title ?? 'Alarm'}',
        'Time to wake up!',
        scheduledTZ,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        // uiLocalNotificationDateInterpretation:
        //     UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: alarm.alarmWeekdays?.isNotEmpty == true
            ? null
            : DateTimeComponents.time,
        payload: 'alarm_${alarm.id}',
      );
    } catch (e) {
      debugPrint('Error scheduling alarm: $e');
      rethrow;
    }
  }

  Future<void> _cancelScheduledAlarm(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllAlarms() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Alarm? getAlarmById(int id) {
    try {
      return _alarms.firstWhere((alarm) => alarm.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Alarm> getActiveAlarms() {
    return _alarms.where((alarm) => alarm.isEnabled == true).toList();
  }

  bool alarmExists(int id) {
    return _alarms.any((alarm) => alarm.id == id);
  }

  Future<void> clearAllAlarms() async {
    _alarms.clear();
    await _saveAlarms();
    await cancelAllAlarms();
  }
}
