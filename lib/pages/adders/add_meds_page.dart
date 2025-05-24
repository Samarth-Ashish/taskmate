import 'package:flutter/material.dart';
import 'package:taskmate/callbacks/alarm_controller.dart';
import 'package:taskmate/models/medicine.module.dart';
import 'package:taskmate/views/custom_app_bar.dart';
import 'package:taskmate/views/gradient_body.dart';
import 'package:taskmate/views/texts.dart';

class AddMedsPage extends StatefulWidget {
  const AddMedsPage({super.key});

  @override
  State<AddMedsPage> createState() => _AddMedsPageState();
}

class _AddMedsPageState extends State<AddMedsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        customTitle: 'Add Medicine',
        isCenterTitle: true,
      ),
      body: AlarmTimeSelector(
        onAlarmCreated: (medicine) async {
          // add medicine
          setState(() {
            Navigator.of(
              context,
            ).pop(true); // Return success to previous screen
            MedicineModel.addMedicine(medicine);
          });
        },
      ),
    );
  }
}

class AlarmTimeSelector extends StatefulWidget {
  final void Function(MedicineModel) onAlarmCreated;

  const AlarmTimeSelector({super.key, required this.onAlarmCreated});

  @override
  State<AlarmTimeSelector> createState() => _AlarmTimeSelectorState();
}

class _AlarmTimeSelectorState extends State<AlarmTimeSelector> {
  int hour = 6;
  int minute = 10;
  bool isAm = false;
  List<bool> selectedDays = List.generate(7, (_) => false);
  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _medicineQuantityController =
      TextEditingController();

  final List<String> days = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

  void incrementHour() => setState(() => hour = (hour % 12) + 1);
  void decrementHour() => setState(() => hour = (hour - 2 + 12) % 12 + 1);
  void incrementMinute() => setState(() => minute = (minute + 1) % 60);
  void decrementMinute() => setState(() => minute = (minute - 1 + 60) % 60);

  @override
  void dispose() {
    _medicineNameController.dispose();
    _medicineQuantityController.dispose();
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

                const SizedBox(height: 20),

                // Alarm Name Input
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _medicineNameController,
                    decoration: InputDecoration(
                      hintText: 'Medicine Name',
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

                const SizedBox(height: 10),

                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _medicineQuantityController,
                    decoration: InputDecoration(
                      hintText: 'Medicine Quantity',
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

  //   final medicine = MedicineModel(
  //     id: DateTime.now().millisecondsSinceEpoch,
  //     title: _medicineNameController.text.trim().isNotEmpty
  //         ? _medicineNameController.text.trim()
  //         : 'Alarm',
  //     alarmTime: TimeOfDay(hour: hour24, minute: minute),
  //     isEnabled: true,
  //     alarmWeekdays: weekdays,
  //   );

  //   widget.onAlarmCreated(medicine);
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

    final medicine = MedicineModel(
      id: DateTime.now().millisecondsSinceEpoch,
      medicineName: _medicineNameController.text.trim().isNotEmpty
          ? _medicineNameController.text.trim()
          : 'Medicine',
      medicineQuantity: _medicineQuantityController.text.trim().isNotEmpty
          ? _medicineQuantityController.text.trim()
          : 'Quantity',
      medicineTime: TimeOfDay(hour: hour24, minute: minute),
      isEnabled: true,
      medicineWeekdays: weekdays,
    );

    // Save to persistent storage
    MedicineModel.addMedicine(medicine);

    // Schedule the medicine (assuming AlarmController has this method)
    // await AlarmController.scheduleAlarm(medicine);

    widget.onAlarmCreated(medicine);
    // if (context.mounted) {
    //   Navigator.of(context).pop(true); // Return success to previous screen
    // }
  }
}
