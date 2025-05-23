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
  // Sample data - in a real app, this would come from a database
  final List<Alarm> _alarms = [
    Alarm(
      id: 1,
      title: 'Morning Alarm',
      alarmTime: const TimeOfDay(hour: 7, minute: 0),
      isEnabled: true,
      alarmWeekdays: [1, 2, 3, 4, 5], // Monday to Friday
    ),
    Alarm(
      id: 2,
      title: 'Workout',
      alarmTime: const TimeOfDay(hour: 18, minute: 30),
      isEnabled: true,
      alarmWeekdays: [2, 4, 6], // Tuesday, Thursday, Saturday
    ),
  ];

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
                onDismissed: (direction) {
                  setState(() {
                    _alarms.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Alarm "${alarm.title}" deleted'),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          setState(() {
                            _alarms.insert(index, alarm);
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
                                _alarms[index] = alarm..isEnabled = value;
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
