import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:taskmate/callbacks/alarm_callback.dart';

class LearningModel {
  int? id;
  String? subjectName;
  String? studyDuration;
  TimeOfDay? studyTime;
  bool isEnabled;
  List<int> studyWeekdays;

  LearningModel({
    this.id,
    this.subjectName,
    this.studyDuration,
    this.studyTime,
    this.isEnabled = true,
    this.studyWeekdays = const [],
  });

  factory LearningModel.fromMap(Map<String, dynamic> json) => LearningModel(
    id: json["id"],
    subjectName: json["subjectName"],
    studyDuration: json["studyDuration"],
    studyTime: TimeOfDay.fromDateTime(DateTime.parse(json["studyTime"])),
    isEnabled: json["isEnabled"] ?? true,
    studyWeekdays: List<int>.from(json["studyWeekdays"] ?? []),
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subjectName': subjectName,
      'studyDuration': studyDuration,
      'studyTime': studyTime != null
          ? '${studyTime!.hour}:${studyTime!.minute}'
          : null,
      'isEnabled': isEnabled,
      'studyWeekdays': studyWeekdays,
    };
  }

  factory LearningModel.fromJson(Map<String, dynamic> json) {
    TimeOfDay? time;
    if (json['studyTime'] != null) {
      final timeParts = (json['studyTime'] as String).split(':');
      time = TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      );
    }

    return LearningModel(
      id: json['id'],
      subjectName: json['subjectName'],
      studyDuration: json['studyDuration'],
      studyTime: time,
      isEnabled: json['isEnabled'] ?? true,
      studyWeekdays: List<int>.from(json['studyWeekdays'] ?? []),
    );
  }

  String getstudyTime() =>
      '${studyTime!.hour.toString().padLeft(2, '0')}:${studyTime!.minute.toString().padLeft(2, '0')}';

  String getstudyWeekdaysString() {
    if (studyWeekdays.isEmpty) return 'None';
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return studyWeekdays.map((d) => days[d % 7 - 1]).join(', ');
  }

  static Future<String?> getLearningTitleById(int id) async {
    final subjects = await loadSubjects();
    final subject = subjects.firstWhere(
      (a) => a.id == id,
      orElse: () => LearningModel(),
    );
    return subject.subjectName;
  }

  static const _key = 'subjects';

  static Future<void> saveSubjects(List<LearningModel> subjects) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = subjects
        .map((subject) => json.encode(subject.toJson()))
        .toList();
    await prefs.setStringList(_key, encoded);
  }

  static Future<List<LearningModel>> loadSubjects() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? encoded = prefs.getStringList(_key);
    if (encoded == null) return [];
    return encoded.map((e) => LearningModel.fromJson(json.decode(e))).toList();
  }

  static Future<void> addSubject(LearningModel subject) async {
    final subjects = await loadSubjects();
    subject.id = subject.id ?? DateTime.now().millisecondsSinceEpoch;
    subjects.add(subject);
    await saveSubjects(subjects);

    if (subject.isEnabled) {
      await subject.schedule();
    }
  }

  static Future<void> removeSubject(int id) async {
    final subjects = await loadSubjects();
    final subject = subjects.firstWhere(
      (a) => a.id == id,
      orElse: () => LearningModel(),
    );
    await subject.cancel();
    subjects.removeWhere((a) => a.id == id);
    await saveSubjects(subjects);
  }

  static Future<LearningModel?> getLearningById(int id) async {
    final subjects = await loadSubjects();
    return subjects.firstWhere((a) => a.id == id);
  }

  static Future<void> setLearningEnabled(int id, bool enabled) async {
    final subjects = await loadSubjects();
    for (var a in subjects) {
      if (a.id == id) {
        a.isEnabled = enabled;
        break;
      }
    }
    await saveSubjects(subjects);
  }

  /// Schedule repeating learning for selected weekdays
  Future<void> schedule() async {
    if (studyTime == null || !isEnabled || studyWeekdays.isEmpty) return;

    for (int weekday in studyWeekdays) {
      final now = DateTime.now();
      DateTime next = DateTime(
        now.year,
        now.month,
        now.day,
        studyTime!.hour,
        studyTime!.minute,
      );

      while (next.weekday != weekday || next.isBefore(now)) {
        next = next.add(Duration(days: 1));
      }

      final duration = next.difference(now);
      int subjectId =
          (id ?? hashCode) % 1000000000 + weekday; // Unique ID per weekday

      await AndroidAlarmManager.periodic(
        const Duration(days: 7),
        subjectId % 100000000,
        alarmCallback,
        startAt: DateTime.now().add(duration),
        exact: true,
        wakeup: true,
      );

      debugPrint(
        "Scheduled subject for '$subjectName' (${studyDuration ?? ''}) every ${['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][weekday - 1]} at ${getstudyTime()}",
      );
    }
  }

  Future<void> cancel() async {
    for (int weekday in studyWeekdays) {
      int subjectId = (id ?? hashCode) % 1000000000 + weekday;
      await AndroidAlarmManager.cancel(subjectId);
    }
  }

  static Future<void> syncLearningWithSystem() async {
    final subjects = await loadSubjects();

    for (var learning in subjects) {
      await learning.cancel();
    }

    for (var learning in subjects) {
      if (learning.isEnabled) {
        await learning.schedule();
      }
    }

    debugPrint('Learning synchronized with system');
  }

  static Future<MapEntry<LearningModel, DateTime>?>
  getNextUpcomingAlarmWithTime() async {
    final alarms = await loadSubjects();
    final now = DateTime.now();
    DateTime? nearestTime;
    LearningModel? nextAlarm;

    for (final learning in alarms) {
      if (!learning.isEnabled ||
          learning.studyTime == null ||
          learning.studyWeekdays.isEmpty) {
        continue;
      }

      for (final weekday in learning.studyWeekdays) {
        DateTime candidate = DateTime(
          now.year,
          now.month,
          now.day,
          learning.studyTime!.hour,
          learning.studyTime!.minute,
        );

        int currentWeekday = candidate.weekday;
        int daysUntilNext = (weekday - currentWeekday + 7) % 7;

        if (daysUntilNext == 0 && candidate.isBefore(now)) {
          daysUntilNext = 7;
        }

        candidate = candidate.add(Duration(days: daysUntilNext));

        if (nearestTime == null || candidate.isBefore(nearestTime)) {
          nearestTime = candidate;
          nextAlarm = learning;
        }
      }
    }

    return (nextAlarm != null && nearestTime != null)
        ? MapEntry(nextAlarm, nearestTime)
        : null;
  }

  static Future<int> getRemainingStudySessionsCount() async {
    final sessions = await loadSubjects();
    final now = DateTime.now();
    int count = 0;

    for (final session in sessions) {
      if (!session.isEnabled || session.studyTime == null) continue;

      // Check if today is a selected study weekday
      // if (!session.studyWeekdays.contains(now.weekday)) continue;

      // Construct the scheduled DateTime for today
      final scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        session.studyTime!.hour,
        session.studyTime!.minute,
      );

      // Count it only if the time hasn't passed yet
      if (scheduledTime.isAfter(now)) {
        count++;
      }
    }

    return count;
  }
}
