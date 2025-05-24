import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmate/views/texts.dart';
import '../models/alarm.module.dart';
import 'adders/add_alarm_page.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  late List<AlarmModel> _alarms = [];

  @override
  void initState() {
    super.initState();
    _loadAlarms();
  }

  Future<void> _loadAlarms() async {
    final alarms = await AlarmModel.loadAlarms();
    setState(() {
      _alarms = alarms;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _alarms.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.alarm_add,
                  size: 64,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'No alarms set',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap + to add an alarm',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: _alarms.length,
            itemBuilder: (context, index) {
              final alarm = _alarms[index];

              return Dismissible(
                key: Key(alarm.id.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) async {
                  // Perform async work first
                  await AlarmModel.removeAlarm(alarm.id!);
                  _alarms.removeWhere((a) => a.id == alarm.id);

                  // Then update the state synchronously
                  setState(() {
                    alarm.isEnabled = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('AlarmModel "${alarm.title}" deleted'),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () async {
                          await AlarmModel.addAlarm(alarm);
                          _alarms.insert(index, alarm);
                          setState(() {
                            alarm.isEnabled = true;
                          });
                        },
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Card(
                    color: Color(0xFF86D0FF),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    shadowColor: Colors.blue,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          // Inner shadow
                          // BoxShadow(
                          //   color: Colors.blue.withOpacity(0.3),
                          //   spreadRadius: 1,
                          //   blurRadius: 5,
                          //   offset: Offset(0, 2),
                          // ),
                          // Outer shadow
                          // BoxShadow(
                          //   color: Colors.blue.withOpacity(0.1),
                          //   spreadRadius: -5,
                          //   blurRadius: 2,
                          //   offset: Offset(10, 10),
                          // ),
                        ],
                      ),
                      child: ListTile(
                        // contentPadding: const EdgeInsets.symmetric(
                        //   horizontal: 16,
                        //   vertical: 8,
                        // ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Text(
                                //   _formatTime(
                                //     alarm.alarmTime ??
                                //         const TimeOfDay(hour: 0, minute: 0),
                                //   ),
                                //   style: const TextStyle(
                                //     fontSize: 24,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                                manjari(
                                  _formatTime(
                                    alarm.alarmTime ??
                                        const TimeOfDay(hour: 0, minute: 0),
                                  ),
                                  fontSize: 28,
                                ),
                                manjari(
                                  alarm.title ?? ' ',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            ),
                            const Spacer(),
                            Switch(
                              value: alarm.isEnabled ?? false,
                              activeColor: Color.fromARGB(255, 113, 186, 243),
                              activeTrackColor: Color(0xFF1776BF),
                              inactiveTrackColor: Color(0xFF86D0FF),
                              onChanged: (bool value) {
                                setState(() {
                                  alarm.isEnabled = value;
                                  AlarmModel.setAlarmEnabled(alarm.id!, value);
                                });
                              },
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(color: Color(0xFF6FC0F4), thickness: 1.5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                manjari(
                                  _formatWeekdays(alarm.alarmWeekdays ?? []),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                manjari(
                                  "Edit",
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // child: Neumorphic(
                //   style: NeumorphicStyle(
                //     shape: NeumorphicShape.concave,
                //     boxShape: NeumorphicBoxShape.roundRect(
                //       BorderRadius.circular(12),
                //     ),
                //     depth: 8,
                //     lightSource: LightSource.topLeft,
                //     color: Colors.grey,
                //   ),
                //   child: Icon(Icons.alarm),
                // ),
              );
            },
          );
  }

  String _formatTime(TimeOfDay time) {
    final hour = (time.hour % 12).toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute ${time.hour < 12 ? 'AM' : 'PM'}';
  }

  String _formatWeekdays(List<int> weekdays) {
    if (weekdays.isEmpty) return 'Never';
    if (weekdays.length == 7) return 'Every day';

    final weekDayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final selectedDays = weekdays.map((day) => weekDayNames[day - 1]).toList();

    return selectedDays.join(', ');
  }
}
