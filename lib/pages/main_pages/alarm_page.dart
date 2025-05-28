import 'package:flutter/material.dart';
import 'package:taskmate/utils/snackbar_utils.dart';
import 'package:taskmate/views/texts.dart';
import '../../models/alarm.module.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => AlarmPageState();
}

class AlarmPageState extends State<AlarmPage> {
  late List<Alarm> _alarms = [];

  @override
  void initState() {
    super.initState();
    loadAlarms();
  }

  Future<void> loadAlarms() async {
    final alarms = await Alarm.loadAlarms();
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
                  color: Color.fromARGB(255, 0, 99, 175),
                ),
                const SizedBox(height: 16),
                manjariSmall('No alarms added', fontWeight: FontWeight.w600),
                // const SizedBox(height: 8),
                // manjariExtraSmall('Tap + to add an alarm'),
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
                  final removedAlarm = alarm;

                  setState(() {
                    _alarms.removeWhere((a) => a.id == removedAlarm.id);
                  });

                  Future.microtask(() async {
                    await Alarm.removeAlarm(removedAlarm.id);
                    SnackbarUtil.showSnackbar(
                      'Alarm "${removedAlarm.title}" deleted',
                    );
                  });
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
                        boxShadow: [],
                      ),
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                manjari(
                                  _formatTime(
                                    alarm.alarmTime ??
                                        const TimeOfDay(hour: 0, minute: 0),
                                  ),
                                  fontSize: 28,
                                ),
                                manjari(
                                  alarm.title ?? ' ',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            ),
                            const Spacer(),
                            Switch(
                              value: alarm.isEnabled,
                              activeColor: Color.fromARGB(255, 113, 186, 243),
                              activeTrackColor: Color(0xFF1776BF),
                              inactiveTrackColor: Color.fromARGB(
                                0,
                                134,
                                209,
                                255,
                              ),
                              onChanged: (bool value) {
                                setState(() {
                                  alarm.isEnabled = value;
                                  Alarm.setAlarmEnabled(alarm.id, value);
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
                                // manjari(
                                //   "Edit",
                                //   fontSize: 15,
                                //   fontWeight: FontWeight.w500,
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }

  String _formatTime(TimeOfDay time) {
    final hour = (time.hour % 12 == 0 ? 12 : time.hour % 12).toString().padLeft(
      2,
      '0',
    );
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute ${time.hour < 12 ? 'AM' : 'PM'}';
  }

  String _formatWeekdays(List<int> weekdays) {
    if (weekdays.isEmpty) return 'Never';
    if (weekdays.length == 7) return 'Every day';

    final weekDayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    weekdays.sort(); // ensure order

    List<String> result = [];
    int start = weekdays[0];
    int end = start;

    for (int i = 1; i < weekdays.length; i++) {
      if (weekdays[i] == end + 1) {
        end = weekdays[i];
      } else {
        result.add(_formatRange(start, end, weekDayNames));
        start = weekdays[i];
        end = start;
      }
    }
    result.add(_formatRange(start, end, weekDayNames));

    return result.join(', ');
  }

  String _formatRange(int start, int end, List<String> names) {
    if (start == end) {
      return names[start - 1];
    } else {
      return '${names[start - 1]}-${names[end - 1]}';
    }
  }
}
