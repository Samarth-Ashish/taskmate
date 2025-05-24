import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmate/models/medicine.module.dart';
import 'package:taskmate/views/texts.dart';
import '../models/medicine.module.dart';
import 'adders/add_meds_page.dart';

class MedicinePage extends StatefulWidget {
  const MedicinePage({super.key});

  @override
  State<MedicinePage> createState() => _MedicinePageState();
}

class _MedicinePageState extends State<MedicinePage> {
  late List<MedicineModel> _medicines = [];

  @override
  void initState() {
    super.initState();
    _loadMedicines();
  }

  Future<void> _loadMedicines() async {
    final medicines = await MedicineModel.loadMedicines();
    setState(() {
      _medicines = medicines;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _medicines.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.medication_outlined,
                  size: 64,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'No medicines set',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap + to add an medicine',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: _medicines.length,
            itemBuilder: (context, index) {
              final medicine = _medicines[index];

              return Dismissible(
                key: Key(medicine.id.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) async {
                  await MedicineModel.removeMedicine(medicine.id!);
                  _medicines.removeAt(index);
                  setState(() {
                    medicine.isEnabled = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'MedicineModel "${medicine.medicineName}" deleted',
                      ),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () async {
                          await MedicineModel.addMedicine(medicine);
                          _medicines.insert(index, medicine);
                          setState(() {
                            medicine.isEnabled = true;
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
                            Icon(
                              Icons.medication,
                              size: 40,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Text(
                                //   _formatTime(
                                //     medicine.alarmTime ??
                                //         const TimeOfDay(hour: 0, minute: 0),
                                //   ),
                                //   style: const TextStyle(
                                //     fontSize: 24,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                                manjari(
                                  medicine.medicineName ?? "Medicine",
                                  fontSize: 32,
                                ),
                                manjari(
                                  medicine.medicineQuantity!,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            ),
                            const Spacer(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: medicine.isEnabled
                                    ? const Color.fromARGB(255, 111, 190, 255)
                                    : const Color.fromARGB(255, 157, 211, 255),
                              ),
                              onPressed: () {
                                setState(() {
                                  medicine.isEnabled = !medicine.isEnabled;
                                });
                                MedicineModel.setMedicineEnabled(
                                  medicine.id!,
                                  medicine.isEnabled,
                                );
                              },
                              child: Text(
                                medicine.isEnabled ? 'Mark Taken' : 'Taken',
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          children: [
                            SizedBox(height: 8),
                            Row(
                              children: [
                                SizedBox(width: 58),
                                manjari(
                                  _formatTime(
                                    medicine.medicineTime ??
                                        const TimeOfDay(hour: 0, minute: 0),
                                  ),
                                  fontSize: 22,
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
                //   child: Icon(Icons.medicine),
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
