import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:taskmate/callbacks/notif_callbacks/alarm_callback.dart';

class Alarm {
  int id;
  String? title;
  TimeOfDay? alarmTime;

  bool isEnabled;
  List<int> alarmWeekdays;

  Alarm({
    required this.id,
    this.title,
    this.alarmTime,
    this.isEnabled = true,
    this.alarmWeekdays = const [],
  });

  factory Alarm.fromMap(Map<String, dynamic> json) => Alarm(
    id: json["id"],
    title: json["title"],
    alarmTime: TimeOfDay.fromDateTime(DateTime.parse(json["alarmTime"])),
    isEnabled: json["isEnabled"] ?? true,
    alarmWeekdays: List<int>.from(json["alarmWeekdays"] ?? []),
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'alarmTime': alarmTime != null
          ? '${alarmTime!.hour}:${alarmTime!.minute}'
          : null,
      'isEnabled': isEnabled,
      'alarmWeekdays': alarmWeekdays,
    };
  }

  factory Alarm.fromJson(Map<String, dynamic> json) {
    TimeOfDay? time;
    if (json['alarmTime'] != null) {
      final timeParts = (json['alarmTime'] as String).split(':');
      time = TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      );
    }

    return Alarm(
      id: json['id'],
      title: json['title'],
      alarmTime: time,
      isEnabled: json['isEnabled'] ?? true,
      alarmWeekdays: List<int>.from(json['alarmWeekdays'] ?? []),
    );
  }

  String getAlarmTime() =>
      '${alarmTime!.hour.toString().padLeft(2, '0')}:${alarmTime!.minute.toString().padLeft(2, '0')}';

  String getAlarmWeekdaysString() {
    if (alarmWeekdays.isEmpty) return 'None';
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return alarmWeekdays.map((d) => days[d % 7 - 1]).join(', ');
  }

  static Future<String?> getAlarmTitleById(int id) async {
    debugPrint("---------- Getting alarm title by ID $id ----------");
    final alarms = await loadAlarms();
    debugPrint(
      "---------- Current Alarms: ${alarms.map((a) => a.id).join(', ')} ----------",
    );
    try {
      final alarm = alarms.firstWhere((a) => a.id == id);
      return alarm.title;
    } catch (e) {
      // debugPrint("No alarm found for the given ID");
      return null;
    }
  }

  static const _key = 'alarms';

  static Future<void> saveAlarms(List<Alarm> alarms) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = alarms.map((alarm) => json.encode(alarm.toJson())).toList();
    await prefs.setStringList(_key, encoded);
    debugPrint(
      'Alarm saved: ${encoded.map((e) => json.decode(e)['id']).join(', ')}',
    );
  }

  static Future<List<Alarm>> loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? encoded = prefs.getStringList(_key);
    debugPrint(
      'All alarm IDs: ${encoded?.map((e) => json.decode(e)['id']).join(', ') ?? 'none'}',
    );
    if (encoded == null) return [];
    return encoded.map((e) => Alarm.fromJson(json.decode(e))).toList();
  }

  static Future<void> addAlarm(Alarm alarm) async {
    final alarms = await loadAlarms();
    alarm.id = alarm.id;
    alarms.add(alarm);
    await saveAlarms(alarms);

    if (alarm.isEnabled) {
      await alarm.schedule();
    }
  }

  static Future<void> removeAlarm(int id) async {
    final alarms = await loadAlarms();
    final alarm = alarms.firstWhere((a) => a.id == id);
    await alarm.cancel();
    alarms.removeWhere((a) => a.id == id);
    await saveAlarms(alarms);
  }

  static Future<Alarm?> getAlarmById(int id) async {
    final alarms = await loadAlarms();
    return alarms.firstWhere((a) => a.id == id);
  }

  static Future<void> setAlarmEnabled(int id, bool enabled) async {
    final alarms = await loadAlarms();
    for (var a in alarms) {
      if (a.id == id) {
        a.isEnabled = enabled;
        if (enabled) {
          await a.schedule();
        } else {
          await a.cancel();
        }
        break;
      }
    }
    await saveAlarms(alarms);
  }

  // Schedule repeating alarm for selected weekdays
  Future<void> schedule() async {
    debugPrint("---------- Scheduling alarm $id ----------");
    if (alarmTime == null || !isEnabled || alarmWeekdays.isEmpty) return;

    for (int weekday in alarmWeekdays) {
      final now = DateTime.now();
      DateTime next = DateTime(
        now.year,
        now.month,
        now.day,
        alarmTime!.hour,
        alarmTime!.minute,
      );

      while (next.weekday != weekday || next.isBefore(now)) {
        next = next.add(Duration(days: 1));
      }

      final duration = next.difference(now);
      int alarmId = id + weekday; // Unique ID per weekday

      debugPrint(
        "~~~~~~~~~~~~  Alarm will ring in ${duration.inHours} hours and ${duration.inMinutes} minutes and ${duration.inSeconds % 60} seconds",
      );
      debugPrint(
        "~~~~~~~~~~~~  Alarm starts at ${DateTime.now().add(duration)}",
      );
      await AndroidAlarmManager.periodic(
        const Duration(days: 7),
        alarmId,
        alarmCallback,
        startAt: DateTime.now().add(duration),
        exact: true,
        allowWhileIdle: true,
        wakeup: true,
      );

      debugPrint(
        "---------- Scheduled repeating alarm $id '$title' every ${['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][weekday - 1]} at ${getAlarmTime()}",
      );
    }
  }

  // Cancel
  Future<void> cancel() async {
    for (int weekday in alarmWeekdays) {
      int alarmId = id + weekday;
      await AndroidAlarmManager.cancel(alarmId);
    }
  }

  static Future<void> syncAlarmsWithSystem() async {
    final alarms = await loadAlarms();

    for (var alarm in alarms) {
      await alarm.cancel();
    }
    for (var alarm in alarms) {
      if (alarm.isEnabled) {
        await alarm.schedule();
      }
    }

    debugPrint('Alarms synchronized with system');
  }

  
  static Future<void> removeAllAlarms() async {
    final alarms = await loadAlarms();

    for (var alarm in alarms) {
      await removeAlarm(alarm.id);
    }

    await saveAlarms([]);

    debugPrint('All alarms removed');
  }


  static Future<MapEntry<Alarm, DateTime>?>
  getNextUpcomingAlarmWithTime() async {
    final alarms = await loadAlarms();
    final now = DateTime.now();
    DateTime? nearestTime;
    Alarm? nextAlarm;

    for (final alarm in alarms) {
      if (!alarm.isEnabled ||
          alarm.alarmTime == null ||
          alarm.alarmWeekdays.isEmpty) {
        continue;
      }

      for (final weekday in alarm.alarmWeekdays) {
        DateTime candidate = DateTime(
          now.year,
          now.month,
          now.day,
          alarm.alarmTime!.hour,
          alarm.alarmTime!.minute,
        );

        int currentWeekday = candidate.weekday;
        int daysUntilNext = (weekday - currentWeekday + 7) % 7;

        if (daysUntilNext == 0 && candidate.isBefore(now)) {
          daysUntilNext = 7;
        }

        candidate = candidate.add(Duration(days: daysUntilNext));

        if (nearestTime == null || candidate.isBefore(nearestTime)) {
          nearestTime = candidate;
          nextAlarm = alarm;
        }
      }
    }

    return (nextAlarm != null && nearestTime != null)
        ? MapEntry(nextAlarm, nearestTime)
        : null;
  }
}
