import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:taskmate/notif_callbacks/learning_callback.dart';

class Subject {
  int id;
  String? subjectName;
  String? studyDuration;
  TimeOfDay? studyTime;
  bool isEnabled;
  List<int> studyWeekdays;

  Subject({
    required this.id,
    this.subjectName,
    this.studyDuration,
    this.studyTime,
    this.isEnabled = true,
    this.studyWeekdays = const [],
  });

  factory Subject.fromMap(Map<String, dynamic> json) => Subject(
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

  factory Subject.fromJson(Map<String, dynamic> json) {
    TimeOfDay? time;
    if (json['studyTime'] != null) {
      final timeParts = (json['studyTime'] as String).split(':');
      time = TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      );
    }

    return Subject(
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

  static Future<String?> getSubjectTitleById(int id) async {
    debugPrint("---------- Getting subject title by ID $id ----------");
    final subjects = await loadSubjects();
    debugPrint(
      "---------- Current Subjects: ${subjects.map((a) => a.id).join(', ')} ----------",
    );
    try {
      final subject = subjects.firstWhere((a) => a.id == id);
      return subject.subjectName;
    } catch (e) {
      // debugPrint("No subject found for the given ID");
      return null;
    }
  }

  static const _key = 'subjects';

  static Future<void> saveSubjects(List<Subject> subjects) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = subjects
        .map((subject) => json.encode(subject.toJson()))
        .toList();
    await prefs.setStringList(_key, encoded);
    debugPrint(
      'Subject saved: ${encoded.map((e) => json.decode(e)['id']).join(', ')}',
    );
  }

  static Future<List<Subject>> loadSubjects() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? encoded = prefs.getStringList(_key);
    debugPrint(
      'All Subjects List: ${encoded?.map((e) => json.decode(e)['id']).join(', ')}',
    );
    if (encoded == null) return [];
    return encoded.map((e) => Subject.fromJson(json.decode(e))).toList();
  }

  static Future<void> addSubject(Subject subject) async {
    final subjects = await loadSubjects();
    subject.id = subject.id;
    subjects.add(subject);
    await saveSubjects(subjects);

    if (subject.isEnabled) {
      await subject.schedule();
    }
  }

  static Future<void> removeSubject(int id) async {
    final subjects = await loadSubjects();
    final subject = subjects.firstWhere((a) => a.id == id);
    await subject.cancel();
    subjects.removeWhere((a) => a.id == id);
    await saveSubjects(subjects);
  }

  static Future<Subject?> getSubjectById(int id) async {
    final subjects = await loadSubjects();
    return subjects.firstWhere((a) => a.id == id);
  }

  static Future<void> setSubjectEnabled(int id, bool enabled) async {
    final subjects = await loadSubjects();
    for (var a in subjects) {
      if (a.id == id) {
        a.isEnabled = enabled;
        break;
      }
    }
    await saveSubjects(subjects);
  }

  // Schedule repeating SubjectSession for selected weekdays
  Future<void> schedule() async {
    debugPrint("---------- Scheduling subject '$id' ----------");
    if (studyTime == null || !isEnabled) return;

    final now = DateTime.now();
    DateTime next = DateTime(
      now.year,
      now.month,
      now.day,
      studyTime!.hour,
      studyTime!.minute,
    );

    while (next.isBefore(now)) {
      next = next.add(Duration(days: 1));
    }

    final duration = next.difference(now);
    int subjectSessionID = id; // Unique ID per weekday

    await AndroidAlarmManager.periodic(
      const Duration(days: 1),
      subjectSessionID,
      studySessionCallback,
      startAt: DateTime.now().add(duration),
      exact: true,
      wakeup: true,
    );

    debugPrint(
      "Scheduled repeating Subject Session '$id' everyday at ${getstudyTime()}",
    );
  }

  // Cancel
  Future<void> cancel() async {
    int subjectSessionID = id;
    await AndroidAlarmManager.cancel(subjectSessionID);
  }

  static Future<void> syncLearningWithSystem() async {
    final subjects = await loadSubjects();

    for (var subjectSession in subjects) {
      await subjectSession.cancel();
    }

    for (var subjectSession in subjects) {
      if (subjectSession.isEnabled) {
        await subjectSession.schedule();
      }
    }

    debugPrint('Learning synchronized with system');
  }

  static Future<MapEntry<Subject, DateTime>?>
  getNextUpcomingSubjectWithTime() async {
    final subjectSessions = await loadSubjects();
    final now = DateTime.now();
    DateTime? nearestTime;
    Subject? nextSubjectSession;

    for (final subjectSession in subjectSessions) {
      if (!subjectSession.isEnabled ||
          subjectSession.studyTime == null ||
          subjectSession.studyWeekdays.isEmpty) {
        continue;
      }

      for (final weekday in subjectSession.studyWeekdays) {
        DateTime candidate = DateTime(
          now.year,
          now.month,
          now.day,
          subjectSession.studyTime!.hour,
          subjectSession.studyTime!.minute,
        );

        int currentWeekday = candidate.weekday;
        int daysUntilNext = (weekday - currentWeekday + 7) % 7;

        if (daysUntilNext == 0 && candidate.isBefore(now)) {
          daysUntilNext = 7;
        }

        candidate = candidate.add(Duration(days: daysUntilNext));

        if (nearestTime == null || candidate.isBefore(nearestTime)) {
          nearestTime = candidate;
          nextSubjectSession = subjectSession;
        }
      }
    }

    return (nextSubjectSession != null && nearestTime != null)
        ? MapEntry(nextSubjectSession, nearestTime)
        : null;
  }

  static Future<int> getRemainingStudySessionsCount() async {
    final sessions = await loadSubjects();
    final now = DateTime.now();
    int count = 0;

    for (final session in sessions) {
      if (!session.isEnabled || session.studyTime == null) continue;

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
