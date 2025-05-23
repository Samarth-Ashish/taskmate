import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskmate/controllers/alarm_controller.dart';
import 'package:taskmate/views/custom_app_bar.dart';
import 'package:taskmate/views/gradient_body.dart';
import 'package:taskmate/views/texts.dart';
import '../../models/alarm.module.dart';

class AddAlarmPage extends StatefulWidget {
  const AddAlarmPage({super.key});

  @override
  State<AddAlarmPage> createState() => _AddAlarmPageState();
}

class _AddAlarmPageState extends State<AddAlarmPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final List<bool> _selectedDays = List.filled(7, false);
  bool _isEnabled = true;

  final List<String> _weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              surface: Theme.of(context).scaffoldBackgroundColor,
              onSurface:
                  Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _saveAlarm() {
    if (_formKey.currentState!.validate()) {
      final weekdays = <int>[];
      for (var i = 0; i < _selectedDays.length; i++) {
        if (_selectedDays[i]) {
          weekdays.add(i + 1); // Days are 1-7 in the model
        }
      }

      final newAlarm = Alarm(
        id: DateTime.now().millisecondsSinceEpoch,
        title: _titleController.text,
        alarmTime: _selectedTime,
        isEnabled: _isEnabled,
        alarmWeekdays: weekdays,
      );

      Navigator.of(context).pop(newAlarm);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Add Alarm'),
      //   actions: [
      //     TextButton(
      //       onPressed: _saveAlarm,
      //       child: const Text('Save', style: TextStyle(color: Colors.white)),
      //     ),
      //   ],
      // ),
      appBar: CustomAppBar(customTitle: 'Add Alarm', isCenterTitle: true),
      // body: Form(
      //   key: _formKey,
      //   child: ListView(
      //     padding: const EdgeInsets.all(16.0),
      //     children: [
      //       // Time Picker
      //       ListTile(
      //         title: const Text('Time'),
      //         subtitle: Text(
      //           '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
      //           style: const TextStyle(
      //             fontSize: 24,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //         trailing: IconButton(
      //           icon: const Icon(Icons.access_time),
      //           onPressed: () => _selectTime(context),
      //         ),
      //         onTap: () => _selectTime(context),
      //       ),
      //       const Divider(),

      //       // Alarm Title
      //       TextFormField(
      //         controller: _titleController,
      //         decoration: const InputDecoration(
      //           labelText: 'Alarm Name',
      //           hintText: 'Enter alarm name',
      //           border: OutlineInputBorder(),
      //           contentPadding: EdgeInsets.symmetric(
      //             horizontal: 16,
      //             vertical: 12,
      //           ),
      //         ),
      //         validator: (value) {
      //           if (value == null || value.isEmpty) {
      //             return 'Please enter an alarm name';
      //           }
      //           return null;
      //         },
      //       ),
      //       const SizedBox(height: 24),

      //       // Repeat Days
      //       const Text(
      //         'Repeat on',
      //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      //       ),
      //       const SizedBox(height: 8),
      //       Wrap(
      //         spacing: 8.0,
      //         children: List.generate(_weekDays.length, (index) {
      //           return FilterChip(
      //             label: Text(_weekDays[index].substring(0, 3)),
      //             selected: _selectedDays[index],
      //             onSelected: (bool selected) {
      //               setState(() {
      //                 _selectedDays[index] = selected;
      //               });
      //             },
      //             selectedColor: Theme.of(
      //               context,
      //             ).primaryColor.withOpacity(0.2),
      //             checkmarkColor: Theme.of(context).primaryColor,
      //             labelStyle: TextStyle(
      //               color: _selectedDays[index]
      //                   ? Theme.of(context).primaryColor
      //                   : Theme.of(context).textTheme.bodyLarge?.color,
      //               fontWeight: FontWeight.bold,
      //             ),
      //           );
      //         }),
      //       ),
      //       const SizedBox(height: 24),

      //       // Enable/Disable Switch
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           const Text(
      //             'Enable Alarm',
      //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      //           ),
      //           Switch(
      //             value: _isEnabled,
      //             onChanged: (bool value) {
      //               setState(() {
      //                 _isEnabled = value;
      //               });
      //             },
      //             activeColor: Theme.of(context).primaryColor,
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      // ),
      body: AlarmTimeSelector(),
    );
  }
}

class AlarmTimeSelector extends StatefulWidget {
  const AlarmTimeSelector({super.key});

  @override
  State<AlarmTimeSelector> createState() => _AlarmTimeSelectorState();
}

class _AlarmTimeSelectorState extends State<AlarmTimeSelector> {
  int hour = 6;
  int minute = 10;
  bool isAm = false;
  List<bool> selectedDays = List.generate(7, (index) => false);

  final List<String> days = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

  void incrementHour() => setState(() => hour = (hour % 12) + 1);
  void decrementHour() => setState(() => hour = (hour - 2 + 12) % 12 + 1);
  void incrementMinute() => setState(() => minute = (minute + 1) % 60);
  void decrementMinute() => setState(() => minute = (minute - 1 + 60) % 60);

  // final AlarmController _alarmController = AlarmController();
  AlarmController get _alarmController => AlarmController();
  final TextEditingController _alarmNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return gradientBody(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: Colors.lightBlue[100],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _timeColumn(
                      hour.toString().padLeft(2, '0'),
                      incrementHour,
                      decrementHour,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(":", style: TextStyle(fontSize: 40)),
                    ),
                    _timeColumn(
                      minute.toString().padLeft(2, '0'),
                      incrementMinute,
                      decrementMinute,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ToggleButtons(
                  isSelected: [isAm, !isAm],
                  onPressed: (int index) => setState(() => isAm = index == 0),
                  borderRadius: BorderRadius.circular(10),
                  selectedColor: Colors.white,
                  fillColor: Colors.blue[800],
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("AM"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("PM"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(7, (index) {
                    final selected = selectedDays[index];
                    return GestureDetector(
                      onTap: () =>
                          setState(() => selectedDays[index] = !selected),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: selected
                                ? Colors.blue[800]
                                : Colors.lightBlue[100],
                            child: manjari(
                              days[index].substring(0, 2),
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              color: selected
                                  ? Colors.lightBlue[100]!
                                  : Colors.blue[800]!,
                              // style: const TextStyle(
                              //   color: Color.fromARGB(255, 0, 34, 54),
                              //   fontWeight: FontWeight.bold,
                              // ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Text(
                          //   days[index],
                          //   style: const TextStyle(fontWeight: FontWeight.bold),
                          // ),
                        ],
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Alarm Name',
                      hintStyle: const TextStyle(color: Colors.blueAccent),
                      filled: true,
                      fillColor: Colors.lightBlue[200],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveAlarm,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[800],
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Done',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _timeColumn(String value, VoidCallback onUp, VoidCallback onDown) {
    return Column(
      children: [
        IconButton(icon: const Icon(Icons.keyboard_arrow_up), onPressed: onUp),
        Text(
          value,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 2,
                color: Colors.black26,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: onDown,
        ),
      ],
    );
  }

  Future<void> _saveAlarm() async {
    try {
      // Convert 12-hour time to 24-hour format
      final int hour24 = isAm
          ? (hour == 12 ? 0 : hour)
          : (hour == 12 ? 12 : hour + 12);

      // Get selected days (1=Monday, 7=Sunday)
      final List<int> weekdays = [];
      for (int i = 0; i < selectedDays.length; i++) {
        if (selectedDays[i]) {
          weekdays.add(i + 1); // 1=Monday, 2=Tuesday, etc.
        }
      }

      // Create and save the alarm
      final newAlarm = Alarm(
        title: _alarmNameController.text.isNotEmpty
            ? _alarmNameController.text
            : 'Alarm',
        alarmTime: TimeOfDay(hour: hour24, minute: minute),
        isEnabled: true,
        alarmWeekdays: weekdays.isNotEmpty ? weekdays : null,
      );

      await _alarmController.addAlarm(newAlarm);

      if (mounted) {
        Navigator.of(context).pop(true); // Return success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save alarm: $e')));
      }
    }
  }

  @override
  void dispose() {
    _alarmNameController.dispose();
    super.dispose();
  }
}
