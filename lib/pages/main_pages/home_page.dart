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
    setState(() {
    });
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
                      return const CircularProgressIndicator();
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
                              "${(time.hour % 12).toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} ${time.hour < 12 ? 'AM' : 'PM'} "
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
                            if (!snapshot.hasData)
                              return CircularProgressIndicator();
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
                            if (!snapshot.hasData)
                              return CircularProgressIndicator();
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
            // const SizedBox(height: 24),
            // const QuickActions(),
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
  Medicine? nextMedicine;
  DateTime? nextMedicineTime;

  @override
  void initState() {
    super.initState();
    _loadUpcomingTasks();
  }

  Future<void> _loadUpcomingTasks() async {
    final medEntry = await Medicine.getNextUpcomingMedicineWithTime();
    if (medEntry != null) {
      setState(() {
        nextMedicine = medEntry.key;
        nextMedicineTime = medEntry.value;
      });
    }
  }

  Widget _buildActionItem(String title, String time, String buttonText) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$title at $time',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          TextButton(
            onPressed: () {}, // TODO: Add action
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String medicineLabel =
        nextMedicine?.medicineName ?? "No upcoming medicine";
    final String medicineTime = nextMedicineTime != null
        ? DateFormat.jm().format(nextMedicineTime!)
        : "--";

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFB3E5FC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.add_circle, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                'Quick Actions',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildActionItem('Take $medicineLabel', medicineTime, 'Mark Taken'),
          _buildActionItem('Study Math', '45 mins', 'Start Timer'),
          _buildActionItem('Prepare for bed', '9:30 PM', 'Start'),
        ],
      ),
    );
  }
}
