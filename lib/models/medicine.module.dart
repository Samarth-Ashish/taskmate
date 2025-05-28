import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:taskmate/callbacks/notif_callbacks/medicine_callback.dart';

class Medicine {
  int id;
  String? medicineName;
  String? medicineQuantity;
  TimeOfDay? medicineTime;

  bool isEnabled;
  List<int> medicineWeekdays;

  Medicine({
    required this.id,
    this.medicineName,
    this.medicineQuantity,
    this.medicineTime,
    this.isEnabled = true,
    this.medicineWeekdays = const [],
  });

  factory Medicine.fromMap(Map<String, dynamic> json) => Medicine(
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

  factory Medicine.fromJson(Map<String, dynamic> json) {
    TimeOfDay? time;
    if (json['medicineTime'] != null) {
      final timeParts = (json['medicineTime'] as String).split(':');
      time = TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      );
    }

    return Medicine(
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
    debugPrint("---------- Getting medicine title by ID $id ----------");
    final medicines = await loadMedicines();
    debugPrint(
      "---------- Current Medicines: ${medicines.map((a) => a.id).join(', ')} ----------",
    );
    try {
      final medicine = medicines.firstWhere((a) => a.id == id);
      return medicine.medicineName;
    } catch (e) {
      // debugPrint("No medicine found for the given ID");
      return null;
    }
  }

  static Future<String?> getMedicineQuantityById(int id) async {
    debugPrint("---------- Getting medicine quantity by ID $id ----------");
    final medicines = await loadMedicines();
    debugPrint(
      "---------- Current Medicines: ${medicines.map((a) => a.id).join(', ')} ----------",
    );
    try {
      final medicine = medicines.firstWhere((a) => a.id == id);
      return medicine.medicineQuantity;
    } catch (e) {
      // debugPrint("No medicine found for the given ID");
      return null;
    }
  }

  static const _key = 'medicines';

  static Future<void> saveMedicines(List<Medicine> medicines) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = medicines
        .map((medicine) => json.encode(medicine.toJson()))
        .toList();
    await prefs.setStringList(_key, encoded);
    debugPrint(
      'Medicine saved: ${encoded.map((e) => json.decode(e)['id']).join(', ')}',
    );
  }

  static Future<List<Medicine>> loadMedicines() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? encoded = prefs.getStringList(_key);
    debugPrint(
      'All Medicines List: ${encoded?.map((e) => json.decode(e)['id']).join(', ')}',
    );
    if (encoded == null) return [];
    return encoded.map((e) => Medicine.fromJson(json.decode(e))).toList();
  }

  static Future<void> addMedicine(Medicine medicine) async {
    final medicines = await loadMedicines();
    medicine.id = medicine.id;
    medicines.add(medicine);
    await saveMedicines(medicines);

    if (medicine.isEnabled) {
      await medicine.schedule();
    }
  }

  static Future<void> removeMedicine(int id) async {
    final medicines = await loadMedicines();
    final medicine = medicines.firstWhere((a) => a.id == id);
    await medicine.cancel();
    medicines.removeWhere((a) => a.id == id);
    await saveMedicines(medicines);
  }

  static Future<Medicine?> getMedicineById(int id) async {
    final medicines = await loadMedicines();
    return medicines.firstWhere((a) => a.id == id);
  }

  static Future<void> setMedicineEnabled(int id, bool enabled) async {
    final medicines = await loadMedicines();
    for (var a in medicines) {
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
    await saveMedicines(medicines);
  }

  // Schedule repeating medicine for selected weekdays
  Future<void> schedule() async {
    debugPrint("---------- Scheduling medicine '$id' ----------");
    if (medicineTime == null || !isEnabled) return;

    final now = DateTime.now();
    DateTime next = DateTime(
      now.year,
      now.month,
      now.day,
      medicineTime!.hour,
      medicineTime!.minute,
    );

    while (next.isBefore(now)) {
      next = next.add(Duration(days: 1));
    }

    final duration = next.difference(now);
    int medicineId = id;

    debugPrint(
      "~~~~~~~~~~~~  Medicine will ring in ${duration.inHours} hours and ${duration.inMinutes} minutes and ${duration.inSeconds % 60} seconds",
    );
    debugPrint(
      "~~~~~~~~~~~~  Medicine starts at ${DateTime.now().add(duration)}",
    );

    await AndroidAlarmManager.periodic(
      const Duration(days: 1),
      medicineId,
      medicineCallback,
      startAt: DateTime.now().add(duration),
      exact: true,
      allowWhileIdle: true,
      wakeup: true,
    );

    debugPrint(
      "Scheduled repeating medicine '$id' everyday at ${getNextUpcomingMedicine()}",
    );
  }

  // Cancel
  Future<void> cancel() async {
    int medicineId = id;
    await AndroidAlarmManager.cancel(medicineId);
  }

  static Future<void> removeAllMedicines() async {
    final medicines = await loadMedicines();

    for (var medicine in medicines) {
      await removeMedicine(medicine.id);
    }

    await saveMedicines([]);

    debugPrint('All medicines removed');
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

  static Future<Medicine?> getNextUpcomingMedicine() async {
    final medicines = await loadMedicines(); // Load all medicines
    final now = DateTime.now();
    DateTime? nearestTime;
    Medicine? nextMedicine;

    for (final med in medicines) {
      if (!med.isEnabled || med.medicineTime == null) continue;

      // Scheduled time today
      DateTime candidate = DateTime(
        now.year,
        now.month,
        now.day,
        med.medicineTime!.hour,
        med.medicineTime!.minute,
      );

      // If time has passed for today, move to tomorrow
      if (candidate.isBefore(now)) continue;

      // Track nearest one
      if (nearestTime == null || candidate.isBefore(nearestTime)) {
        nearestTime = candidate;
        nextMedicine = med;
      }
    }

    return nextMedicine;
  }

  static Future<int> getRemainingMedicinesCount() async {
    final medicines = await loadMedicines();
    final now = DateTime.now();
    int count = 0;

    for (final medicine in medicines) {
      if (!medicine.isEnabled || medicine.medicineTime == null) continue;

      final scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        medicine.medicineTime!.hour,
        medicine.medicineTime!.minute,
      );

      if (scheduledTime.isAfter(now)) {
        count++;
      }
    }

    return count;
  }
}
