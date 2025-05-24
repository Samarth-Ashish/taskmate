import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:taskmate/callbacks/medicine_callback.dart';

class MedicineModel {
  int? id;
  String? medicineName;
  String? medicineQuantity;
  TimeOfDay? medicineTime;
  bool isEnabled;
  List<int> medicineWeekdays;

  MedicineModel({
    this.id,
    this.medicineName,
    this.medicineQuantity,
    this.medicineTime,
    this.isEnabled = true,
    this.medicineWeekdays = const [],
  });

  factory MedicineModel.fromMap(Map<String, dynamic> json) => MedicineModel(
    id: json["id"],
    medicineName: json["medicineName"],
    medicineQuantity: json["medicineQuantity"],
    medicineTime: TimeOfDay.fromDateTime(DateTime.parse(json["medicineTime"])),
    isEnabled: json["isEnabled"] ?? true,
    medicineWeekdays: List<int>.from(json["medicineWeekdays"] ?? []),
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicineName': medicineName,
      'medicineQuantity': medicineQuantity,
      'medicineTime': medicineTime != null
          ? '${medicineTime!.hour}:${medicineTime!.minute}'
          : null,
      'isEnabled': isEnabled,
      'medicineWeekdays': medicineWeekdays,
    };
  }

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    TimeOfDay? time;
    if (json['medicineTime'] != null) {
      final timeParts = (json['medicineTime'] as String).split(':');
      time = TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      );
    }

    return MedicineModel(
      id: json['id'],
      medicineName: json['medicineName'],
      medicineQuantity: json['medicineQuantity'],
      medicineTime: time,
      isEnabled: json['isEnabled'] ?? true,
      medicineWeekdays: List<int>.from(json['medicineWeekdays'] ?? []),
    );
  }

  String getMedicineTime() =>
      '${medicineTime!.hour.toString().padLeft(2, '0')}:${medicineTime!.minute.toString().padLeft(2, '0')}';

  String getMedicineWeekdaysString() {
    if (medicineWeekdays.isEmpty) return 'None';
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return medicineWeekdays.map((d) => days[d % 7 - 1]).join(', ');
  }

  static Future<String?> getMedicineTitleById(int id) async {
    final medicines = await loadMedicines();
    final medicine = medicines.firstWhere(
      (a) => a.id == id,
      orElse: () => MedicineModel(),
    );
    return medicine.medicineName;
  }

  static const _key = 'medicines';

  static Future<void> saveMedicines(List<MedicineModel> medicines) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = medicines
        .map((medicine) => json.encode(medicine.toJson()))
        .toList();
    await prefs.setStringList(_key, encoded);
  }

  static Future<List<MedicineModel>> loadMedicines() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? encoded = prefs.getStringList(_key);
    if (encoded == null) return [];
    return encoded.map((e) => MedicineModel.fromJson(json.decode(e))).toList();
  }

  static Future<void> addMedicine(MedicineModel medicine) async {
    final medicines = await loadMedicines();
    medicine.id = medicine.id ?? DateTime.now().millisecondsSinceEpoch;
    medicines.add(medicine);
    await saveMedicines(medicines);

    if (medicine.isEnabled) {
      await medicine.schedule();
    }
  }

  static Future<void> removeMedicine(int id) async {
    final medicines = await loadMedicines();
    final medicine = medicines.firstWhere(
      (a) => a.id == id,
      orElse: () => MedicineModel(),
    );
    await medicine.cancel();
    medicines.removeWhere((a) => a.id == id);
    await saveMedicines(medicines);
  }

  static Future<MedicineModel?> getMedicineById(int id) async {
    final medicines = await loadMedicines();
    return medicines.firstWhere((a) => a.id == id);
  }

  static Future<void> setMedicineEnabled(int id, bool enabled) async {
    final medicines = await loadMedicines();
    for (var a in medicines) {
      if (a.id == id) {
        a.isEnabled = enabled;
        break;
      }
    }
    await saveMedicines(medicines);
  }

  /// Schedule repeating medicine for selected weekdays
  Future<void> schedule() async {
    if (medicineTime == null || !isEnabled || medicineWeekdays.isEmpty) return;

    for (int weekday in medicineWeekdays) {
      final now = DateTime.now();
      DateTime next = DateTime(
        now.year,
        now.month,
        now.day,
        medicineTime!.hour,
        medicineTime!.minute,
      );

      while (next.weekday != weekday || next.isBefore(now)) {
        next = next.add(Duration(days: 1));
      }

      final duration = next.difference(now);
      int medicineId =
          (id ?? hashCode) % 1000000000 + weekday; // Unique ID per weekday

      await AndroidAlarmManager.periodic(
        const Duration(days: 7),
        medicineId % 100000000,
        alarmCallback,
        startAt: DateTime.now().add(duration),
        exact: true,
        wakeup: true,
      );

      debugPrint(
        "Scheduled medicine for '$medicineName' (${medicineQuantity ?? ''}) every ${['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][weekday - 1]} at ${getMedicineTime()}",
      );
    }
  }

  Future<void> cancel() async {
    for (int weekday in medicineWeekdays) {
      int medicineId = (id ?? hashCode) % 1000000000 + weekday;
      await AndroidAlarmManager.cancel(medicineId);
    }
  }

  static Future<void> syncMedicinesWithSystem() async {
    final medicines = await loadMedicines();

    for (var medicine in medicines) {
      await medicine.cancel();
    }

    for (var medicine in medicines) {
      if (medicine.isEnabled) {
        await medicine.schedule();
      }
    }

    debugPrint('Medicines synchronized with system');
  }

  static Future<MapEntry<MedicineModel, DateTime>?>
  getNextUpcomingAlarmWithTime() async {
    final alarms = await loadMedicines();
    final now = DateTime.now();
    DateTime? nearestTime;
    MedicineModel? nextAlarm;

    for (final medicine in alarms) {
      if (!medicine.isEnabled ||
          medicine.medicineTime == null ||
          medicine.medicineWeekdays.isEmpty) {
        continue;
      }

      for (final weekday in medicine.medicineWeekdays) {
        DateTime candidate = DateTime(
          now.year,
          now.month,
          now.day,
          medicine.medicineTime!.hour,
          medicine.medicineTime!.minute,
        );

        int currentWeekday = candidate.weekday;
        int daysUntilNext = (weekday - currentWeekday + 7) % 7;

        if (daysUntilNext == 0 && candidate.isBefore(now)) {
          daysUntilNext = 7;
        }

        candidate = candidate.add(Duration(days: daysUntilNext));

        if (nearestTime == null || candidate.isBefore(nearestTime)) {
          nearestTime = candidate;
          nextAlarm = medicine;
        }
      }
    }

    return (nextAlarm != null && nearestTime != null)
        ? MapEntry(nextAlarm, nearestTime)
        : null;
  }

  static Future<int> getRemainingMedicinesCount() async {
    final medicines = await loadMedicines();
    final now = DateTime.now();
    int count = 0;

    for (final medicine in medicines) {
      if (!medicine.isEnabled || medicine.medicineTime == null) continue;

      // Only consider if today is one of the selected weekdays
      // if (!medicine.medicineWeekdays.contains(now.weekday)) continue;

      final scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        medicine.medicineTime!.hour,
        medicine.medicineTime!.minute,
      );

      // Count only if scheduled time is still ahead
      if (scheduledTime.isAfter(now)) {
        count++;
      }
    }

    return count;
  }
}
