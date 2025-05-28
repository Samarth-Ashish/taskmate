import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskmate/models/alarm.module.dart';
import 'package:taskmate/models/learning.module.dart';
import 'package:taskmate/models/medicine.module.dart';
import 'package:taskmate/views/texts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Future<void> refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("____________Building HomePage____________");
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 120, 194, 255),
                        Color.fromARGB(255, 25, 147, 218),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: const Icon(
                    Icons.alarm,
                    size: 30,
                    color: Color.fromARGB(
                      255,
                      51,
                      176,
                      225,
                    ), // This color will be replaced by the gradient
                  ),
                ),
                const SizedBox(width: 8),
                mada('Next Alarm'),
              ],
            ),
            Card(
              color: Color(0xFF86D0FF),
              // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              shadowColor: Colors.blue,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: FutureBuilder<MapEntry<Alarm, DateTime>?>(
                  future: Alarm.getNextUpcomingAlarmWithTime(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox.shrink();
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return Row(
                        children: [manjariSmall("No upcoming alarms")],
                      );
                    }

                    final alarm = snapshot.data!.key;
                    final time = snapshot.data!.value;

                    return Column(
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            manjari(
                              alarm.title ?? 'Alarm',
                              fontSize: 24,
                              // fontWeight: FontWeight.w700,
                            ),
                            manjari(
                              "${(time.hour % 12 == 0 ? 12 : time.hour % 12).toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} ${time.hour < 12 ? 'AM' : 'PM'} "
                              "(${['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][time.weekday - 1]})",
                              fontSize: 18,
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 120, 194, 255),
                        Color.fromARGB(255, 25, 147, 218),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: const Icon(
                    Icons.list_alt,
                    size: 30,
                    color: Color.fromARGB(
                      255,
                      51,
                      176,
                      225,
                    ), // This color will be replaced by the gradient
                  ),
                ),
                const SizedBox(width: 8),
                mada("Today's Summary"),
              ],
            ),
            Card(
              color: Color(0xFF86D0FF),
              // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              shadowColor: Colors.blue,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        manjari("Medications: ", fontSize: 25),
                        FutureBuilder<int>(
                          future: Medicine.getRemainingMedicinesCount(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return SizedBox.shrink();
                            return manjari(
                              '${snapshot.data} Reminders',
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            );
                          },
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        manjari("Sleep: ", fontSize: 25),
                        manjari(
                          '10:00 PM to 06:00 AM',
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        manjari("Learning: ", fontSize: 25),
                        FutureBuilder<int>(
                          future: Subject.getRemainingStudySessionsCount(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return SizedBox.shrink();
                            return manjari(
                              '${snapshot.data} Sessions',
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 120, 194, 255),
                        Color.fromARGB(255, 25, 147, 218),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: const Icon(
                    Icons.add_circle_outline_sharp,
                    size: 30,
                    color: Color.fromARGB(
                      255,
                      51,
                      176,
                      225,
                    ), // This color will be replaced by the gradient
                  ),
                ),
                const SizedBox(width: 8),
                mada("Quick Actions"),
              ],
            ),
            const SizedBox(height: 8),
            const QuickActions(),
          ],
        ),
      ),
    );
  }
}

//!

class QuickActions extends StatefulWidget {
  const QuickActions({super.key});

  @override
  State<QuickActions> createState() => _QuickActionsState();
}

class _QuickActionsState extends State<QuickActions> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF86D0FF),
      // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shadowColor: Colors.blue,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            RecentMedicineActionRow(),
            Divider(color: const Color.fromARGB(255, 116, 192, 255)),
            RecentStudySessionActionRow(),
          ],
        ),
      ),
    );
  }
}

class RecentMedicineActionRow extends StatefulWidget {
  const RecentMedicineActionRow({super.key});

  @override
  State<RecentMedicineActionRow> createState() =>
      _RecentMedicineActionRowState();
}

class _RecentMedicineActionRowState extends State<RecentMedicineActionRow> {
  Medicine? nextMedicine;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadNextMedicine();
  }

  Future<void> loadNextMedicine() async {
    final result = await Medicine.getNextUpcomingMedicine(); // assumed async
    setState(() {
      nextMedicine = result;
      isLoading = false;
    });
  }

  String _formatTime(TimeOfDay time) {
    final hour = (time.hour % 12 == 0 ? 12 : time.hour % 12).toString().padLeft(
      2,
      '0',
    );
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute ${time.hour < 12 ? 'AM' : 'PM'}';
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox.shrink();
    }

    if (nextMedicine == null) {
      return Row(children: [manjariSmall('No upcoming medicines')]);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        mada(nextMedicine!.medicineName!),
        Column(
          children: [
            SizedBox(height: 6),
            manjariSmall(
              _formatTime(
                nextMedicine!.medicineTime ??
                    const TimeOfDay(hour: 0, minute: 0),
              ),
              fontSize: 22,
            ),
          ],
        ),

        ElevatedButton(
          onPressed: () async {
            await Medicine.setMedicineEnabled(
              nextMedicine!.id,
              !nextMedicine!.isEnabled,
            );
            setState(() {
              nextMedicine!.isEnabled = !nextMedicine!.isEnabled;
              loadNextMedicine();
            });
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            backgroundColor: nextMedicine!.isEnabled
                ? const Color.fromARGB(255, 111, 190, 255)
                : const Color.fromARGB(255, 157, 211, 255),
          ),
          child: Text(nextMedicine!.isEnabled ? 'Mark Taken' : '✔️ Taken'),
        ),
      ],
    );
  }
}

class RecentStudySessionActionRow extends StatefulWidget {
  const RecentStudySessionActionRow({super.key});

  @override
  State<RecentStudySessionActionRow> createState() =>
      _RecentStudySessionActionRowState();
}

class _RecentStudySessionActionRowState
    extends State<RecentStudySessionActionRow> {
  Subject? nextSubject;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadNextSubject();
  }

  Future<void> loadNextSubject() async {
    final result = await Subject.getNextUpcomingSubject(); // assumed async
    setState(() {
      nextSubject = result;
      isLoading = false;
    });
  }

  String _formatTime(TimeOfDay time) {
    final hour = (time.hour % 12 == 0 ? 12 : time.hour % 12).toString().padLeft(
      2,
      '0',
    );
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute ${time.hour < 12 ? 'AM' : 'PM'}';
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox.shrink();
    }

    if (nextSubject == null) {
      return Row(children: [manjariSmall('No upcoming study sessions')]);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        mada(nextSubject!.subjectName ?? 'Unnamed Subject'),
        Column(
          children: [
            const SizedBox(height: 6),
            manjariSmall(
              _formatTime(
                nextSubject!.studyTime ?? const TimeOfDay(hour: 0, minute: 0),
              ),
              fontSize: 22,
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () async {
            await Subject.setSubjectEnabled(
              nextSubject!.id,
              !nextSubject!.isEnabled,
            );
            setState(() {
              nextSubject!.isEnabled = !nextSubject!.isEnabled;
              loadNextSubject();
            });
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            backgroundColor: nextSubject!.isEnabled
                ? const Color.fromARGB(255, 111, 190, 255)
                : const Color.fromARGB(255, 157, 211, 255),
          ),
          child: Text(nextSubject!.isEnabled ? 'Mark Studied' : '✔️ Studied'),
        ),
      ],
    );
  }
}
