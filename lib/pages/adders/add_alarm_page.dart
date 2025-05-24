// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:taskmate/controllers/alarm_controller.dart';
// import 'package:taskmate/views/custom_app_bar.dart';
// import 'package:taskmate/views/gradient_body.dart';
// import 'package:taskmate/views/texts.dart';
// import '../../models/alarm.module.dart';

// class AddAlarmPage extends StatefulWidget {
//   const AddAlarmPage({super.key});

//   @override
//   State<AddAlarmPage> createState() => _AddAlarmPageState();
// }

// class _AddAlarmPageState extends State<AddAlarmPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   TimeOfDay _selectedTime = TimeOfDay.now();
//   final List<bool> _selectedDays = List.filled(7, false);
//   bool _isEnabled = true;

//   final List<String> _weekDays = [
//     'Monday',
//     'Tuesday',
//     'Wednesday',
//     'Thursday',
//     'Friday',
//     'Saturday',
//     'Sunday',
//   ];

//   Future<void> _selectTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: _selectedTime,
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: ColorScheme.light(
//               primary: Theme.of(context).primaryColor,
//               onPrimary: Colors.white,
//               surface: Theme.of(context).scaffoldBackgroundColor,
//               onSurface:
//                   Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (picked != null && picked != _selectedTime) {
//       setState(() {
//         _selectedTime = picked;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     super.dispose();
//   }

//   void _saveAlarm() {
//     if (_formKey.currentState!.validate()) {
//       final weekdays = <int>[];
//       for (var i = 0; i < _selectedDays.length; i++) {
//         if (_selectedDays[i]) {
//           weekdays.add(i + 1); // Days are 1-7 in the model
//         }
//       }

//       final newAlarm = AlarmModel(
//         id: DateTime.now().millisecondsSinceEpoch,
//         title: _titleController.text,
//         alarmTime: _selectedTime,
//         isEnabled: _isEnabled,
//         alarmWeekdays: weekdays,
//       );

//       Navigator.of(context).pop(newAlarm);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(customTitle: 'Add AlarmModel', isCenterTitle: true),
//       body: AlarmTimeSelector(),
//     );
//   }
// }

// class AlarmTimeSelector extends StatefulWidget {
//   const AlarmTimeSelector({super.key});

//   @override
//   State<AlarmTimeSelector> createState() => _AlarmTimeSelectorState();
// }

// class _AlarmTimeSelectorState extends State<AlarmTimeSelector> {
//   int hour = 6;
//   int minute = 10;
//   bool isAm = false;
//   List<bool> selectedDays = List.generate(7, (index) => false);

//   final List<String> days = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

//   void incrementHour() => setState(() => hour = (hour % 12) + 1);
//   void decrementHour() => setState(() => hour = (hour - 2 + 12) % 12 + 1);
//   void incrementMinute() => setState(() => minute = (minute + 1) % 60);
//   void decrementMinute() => setState(() => minute = (minute - 1 + 60) % 60);

//   // final AlarmController _alarmController = AlarmController();
//   AlarmController get _alarmController => AlarmController();
//   final TextEditingController _alarmNameController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return gradientBody(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 15),
//             padding: const EdgeInsets.symmetric(vertical: 15),
//             decoration: BoxDecoration(
//               color: Colors.lightBlue[100],
//               borderRadius: BorderRadius.circular(30),
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     _timeColumn(
//                       hour.toString().padLeft(2, '0'),
//                       incrementHour,
//                       decrementHour,
//                     ),
//                     const Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 8),
//                       child: Text(":", style: TextStyle(fontSize: 40)),
//                     ),
//                     _timeColumn(
//                       minute.toString().padLeft(2, '0'),
//                       incrementMinute,
//                       decrementMinute,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 ToggleButtons(
//                   isSelected: [isAm, !isAm],
//                   onPressed: (int index) => setState(() => isAm = index == 0),
//                   borderRadius: BorderRadius.circular(10),
//                   selectedColor: Colors.white,
//                   fillColor: Colors.blue[800],
//                   children: const [
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 20),
//                       child: Text("AM"),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 20),
//                       child: Text("PM"),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: List.generate(7, (index) {
//                     final selected = selectedDays[index];
//                     return GestureDetector(
//                       onTap: () =>
//                           setState(() => selectedDays[index] = !selected),
//                       child: Column(
//                         children: [
//                           CircleAvatar(
//                             radius: 15,
//                             backgroundColor: selected
//                                 ? Colors.blue[800]
//                                 : Colors.lightBlue[100],
//                             child: manjari(
//                               days[index].substring(0, 2),
//                               fontWeight: FontWeight.w900,
//                               fontSize: 14,
//                               color: selected
//                                   ? Colors.lightBlue[100]!
//                                   : Colors.blue[800]!,
//                               // style: const TextStyle(
//                               //   color: Color.fromARGB(255, 0, 34, 54),
//                               //   fontWeight: FontWeight.bold,
//                               // ),
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           // Text(
//                           //   days[index],
//                           //   style: const TextStyle(fontWeight: FontWeight.bold),
//                           // ),
//                         ],
//                       ),
//                     );
//                   }),
//                 ),
//                 const SizedBox(height: 20),
//                 SizedBox(
//                   width: 200,
//                   child: TextField(
//                     decoration: InputDecoration(
//                       hintText: 'AlarmModel Name',
//                       hintStyle: const TextStyle(color: Colors.blueAccent),
//                       filled: true,
//                       fillColor: Colors.lightBlue[200],
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 16,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: _saveAlarm,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue[800],
//               padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//             child: const Text(
//               'Done',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//         ],
//       ),
//     );
//   }

//   Widget _timeColumn(String value, VoidCallback onUp, VoidCallback onDown) {
//     return Column(
//       children: [
//         IconButton(icon: const Icon(Icons.keyboard_arrow_up), onPressed: onUp),
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 40,
//             fontWeight: FontWeight.bold,
//             shadows: [
//               Shadow(
//                 blurRadius: 2,
//                 color: Colors.black26,
//                 offset: Offset(2, 2),
//               ),
//             ],
//           ),
//         ),
//         IconButton(
//           icon: const Icon(Icons.keyboard_arrow_down),
//           onPressed: onDown,
//         ),
//       ],
//     );
//   }

//   Future<void> _saveAlarm() async {
//     try {
//       // Convert 12-hour time to 24-hour format
//       final int hour24 = isAm
//           ? (hour == 12 ? 0 : hour)
//           : (hour == 12 ? 12 : hour + 12);

//       // Get selected days (1=Monday, 7=Sunday)
//       final List<int> weekdays = [];
//       for (int i = 0; i < selectedDays.length; i++) {
//         if (selectedDays[i]) {
//           weekdays.add(i + 1); // 1=Monday, 2=Tuesday, etc.
//         }
//       }

//       // Create and save the alarm
//       final newAlarm = AlarmModel(
//         title: _alarmNameController.text.isNotEmpty
//             ? _alarmNameController.text
//             : 'AlarmModel',
//         alarmTime: TimeOfDay(hour: hour24, minute: minute),
//         isEnabled: true,
//         alarmWeekdays: weekdays.isNotEmpty ? weekdays : null,
//       );

//       await _alarmController.addAlarm(newAlarm);

//       if (mounted) {
//         Navigator.of(context).pop(true); // Return success
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Failed to save alarm: $e')));
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _alarmNameController.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:taskmate/callbacks/alarm_controller.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(customTitle: 'Add Alarm', isCenterTitle: true),
      body: AlarmTimeSelector(
        onAlarmCreated: (alarm) async {
          // add alarm
          setState(() {
            Navigator.of(
              context,
            ).pop(true); // Return success to previous screen
            AlarmModel.loadAlarms();
          });
        },
      ),
    );
  }
}

class AlarmTimeSelector extends StatefulWidget {
  final void Function(AlarmModel) onAlarmCreated;

  const AlarmTimeSelector({super.key, required this.onAlarmCreated});

  @override
  State<AlarmTimeSelector> createState() => _AlarmTimeSelectorState();
}

class _AlarmTimeSelectorState extends State<AlarmTimeSelector> {
  int hour = 6;
  int minute = 10;
  bool isAm = false;
  List<bool> selectedDays = List.generate(7, (_) => false);
  final TextEditingController _alarmNameController = TextEditingController();

  final List<String> days = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

  void incrementHour() => setState(() => hour = (hour % 12) + 1);
  void decrementHour() => setState(() => hour = (hour - 2 + 12) % 12 + 1);
  void incrementMinute() => setState(() => minute = (minute + 1) % 60);
  void decrementMinute() => setState(() => minute = (minute - 1 + 60) % 60);

  @override
  void dispose() {
    _alarmNameController.dispose();
    super.dispose();
  }

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
                // Time Selection
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

                // AM/PM Toggle
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

                // Days Selection
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
                              days[index],
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              color: selected
                                  ? Colors.lightBlue[100]!
                                  : Colors.blue[800]!,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 20),

                // Alarm Name Input
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _alarmNameController,
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

          // Done Button
          ElevatedButton(
            onPressed: _createAndSendAlarm,
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

  // void _createAndSendAlarm() {
  //   final int hour24 = isAm
  //       ? (hour == 12 ? 0 : hour)
  //       : (hour == 12 ? 12 : hour + 12);

  //   final List<int> weekdays = [];
  //   for (int i = 0; i < selectedDays.length; i++) {
  //     if (selectedDays[i]) weekdays.add(i + 1); // 1 = Monday
  //   }

  //   final alarm = AlarmModel(
  //     id: DateTime.now().millisecondsSinceEpoch,
  //     title: _alarmNameController.text.trim().isNotEmpty
  //         ? _alarmNameController.text.trim()
  //         : 'Alarm',
  //     alarmTime: TimeOfDay(hour: hour24, minute: minute),
  //     isEnabled: true,
  //     alarmWeekdays: weekdays,
  //   );

  //   widget.onAlarmCreated(alarm);
  // }
  void _createAndSendAlarm() {
    if (selectedDays == [false, false, false, false, false, false, false]) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one day")),
      );
      return;
    }

    final int hour24 = isAm
        ? (hour == 12 ? 0 : hour)
        : (hour == 12 ? 12 : hour + 12);

    final List<int> weekdays = [];
    // for (int i = 0; i < selectedDays.length; i++) {
    //   // if (selectedDays[i]) {
    //   //   weekdays.add(i == 6 ? 7 : i + 1); // 1 = Monday, 7 = Sunday
    //   // }
    //   if (selectedDays[i]) weekdays.add(i == 6 ? 7 : i + 1);
    // }
    for (int i = 0; i < selectedDays.length; i++) {
      if (selectedDays[i]) weekdays.add(i + 1); // Mo=1, ..., Su=7
    }

    final alarm = AlarmModel(
      id: DateTime.now().millisecondsSinceEpoch,
      title: _alarmNameController.text.trim().isNotEmpty
          ? _alarmNameController.text.trim()
          : 'Alarm',
      alarmTime: TimeOfDay(hour: hour24, minute: minute),
      isEnabled: true,
      alarmWeekdays: weekdays,
    );

    // Save to persistent storage
    AlarmModel.addAlarm(alarm);

    // Schedule the alarm (assuming AlarmController has this method)
    // await AlarmController.scheduleAlarm(alarm);

    widget.onAlarmCreated(alarm);
    // if (context.mounted) {
    //   Navigator.of(context).pop(true); // Return success to previous screen
    // }
  }
}
