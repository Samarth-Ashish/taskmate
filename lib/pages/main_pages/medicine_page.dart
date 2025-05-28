import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:taskmate/models/medicine.module.dart';
import 'package:taskmate/utils/snackbar_utils.dart';
import 'package:taskmate/views/texts.dart';

class MedicinePage extends StatefulWidget {
  const MedicinePage({super.key});

  @override
  State<MedicinePage> createState() => MedicinePageState();
}

class MedicinePageState extends State<MedicinePage> {
  late List<Medicine> _medicines = [];
  // final GlobalKey<MedicinePageState> _medicinePageKey = GlobalKey<MedicinePageState>();

  @override
  void initState() {
    super.initState();
    loadMedicines();
  }

  Future<void> loadMedicines() async {
    final medicines = await Medicine.loadMedicines();
    setState(() {
      _medicines = medicines;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('________Building MedicinePageState________');
    return _medicines.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.medication_outlined,
                  size: 64,
                  color: Color.fromARGB(255, 0, 99, 175),
                ),
                const SizedBox(height: 16),

                manjariSmall('No medicines added', fontWeight: FontWeight.w600),
                // const SizedBox(height: 8),
                // manjariExtraSmall('Tap + to add a medicine'),
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

                onDismissed: (direction) {
                  final removedMedicine = medicine;

                  setState(() {
                    _medicines.removeWhere((a) => a.id == removedMedicine.id);
                  });

                  Future.microtask(() async {
                    await Medicine.removeMedicine(removedMedicine.id);
                    SnackbarUtil.showSnackbar(
                      'Medicine "${removedMedicine.medicineName}" deleted',
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
                    shadowColor: const Color.fromARGB(255, 0, 116, 211),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        // boxShadow: [
                        //   // Outer subtle shadow (optional)
                        //   // BoxShadow(
                        //   //   color: Colors.blue.shade100,
                        //   //   blurRadius: 10,
                        //   //   offset: const Offset(4, 4),
                        //   // ),
                        //   // Simulated inner shadow (top-left)
                        //   const BoxShadow(
                        //     color: Color.fromARGB(174, 0, 81, 139),
                        //     blurRadius: 8,
                        //     offset: Offset(-4, -4),
                        //     spreadRadius: -8,
                        //   ),
                        //   // Simulated inner shadow (bottom-right)
                        //   const BoxShadow(
                        //     color: Color.fromARGB(255, 86, 196, 255),
                        //     blurRadius: 6,
                        //     offset: Offset(4, 4),
                        //     spreadRadius: -2,
                        //   ),
                        // ],
                      ),
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Icon(
                            //   Icons.medication,
                            //   size: 40,
                            //   color: Colors.blue,
                            // ),
                            SvgPicture.asset(
                              'assets/icons/pills-solid.svg',
                              height: 40,
                              colorFilter: ColorFilter.mode(
                                Colors.blue,
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                backgroundColor: medicine.isEnabled
                                    ? const Color.fromARGB(255, 111, 190, 255)
                                    : const Color.fromARGB(255, 157, 211, 255),
                              ),
                              onPressed: () {
                                setState(() {
                                  medicine.isEnabled = !medicine.isEnabled;
                                });
                                Medicine.setMedicineEnabled(
                                  medicine.id,
                                  medicine.isEnabled,
                                );
                              },
                              child: Text(
                                medicine.isEnabled ? 'Mark Taken' : '✔️ Taken',
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
                                  fontWeight: FontWeight.w600,
                                ),
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
    final selectedDays = weekdays.map((day) => weekDayNames[day - 1]).toList();

    return selectedDays.join(', ');
  }
}
