import 'package:flutter/material.dart';
import 'package:taskmate/models/learning.module.dart';
import 'package:taskmate/models/medicine.module.dart';

@pragma('vm:entry-point')
void resetMedicinesAndStudySessionsCallback() async {
  WidgetsFlutterBinding.ensureInitialized();

  final medicines = await Medicine.loadMedicines();
  for (var med in medicines) {
    med.isEnabled = true;
  }

  await Medicine.saveMedicines(medicines);
  await Medicine.syncMedicinesWithSystem();

  //!

  final subjects = await Subject.loadSubjects();
  for (var sub in subjects) {
    sub.isEnabled = true;
  }

  await Subject.saveSubjects(subjects);
  await Subject.syncSubjectWithSystem();

  debugPrint("✅ All medicines and subjects re-enabled at 00:00");
}
