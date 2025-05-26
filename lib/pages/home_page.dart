import 'package:flutter/material.dart';
import 'package:taskmate/models/alarm.module.dart';
import 'package:taskmate/models/learning.module.dart';
import 'package:taskmate/models/medicine.module.dart';
import 'package:taskmate/views/texts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
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
          ],
        ),
      ),
    );
  }
}

class MedicationModel {}
