import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmate/models/learning.module.dart';
import 'package:taskmate/models/learning.module.dart';
import 'package:taskmate/views/texts.dart';

class LearningPage extends StatefulWidget {
  const LearningPage({super.key});

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  late List<LearningModel> _subjects = [];

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    final subjects = await LearningModel.loadSubjects();
    setState(() {
      _subjects = subjects;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _subjects.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.book_online_outlined,
                  size: 64,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'No subjects set',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap + to add an subject',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: _subjects.length,
            itemBuilder: (context, index) {
              final subject = _subjects[index];

              return Dismissible(
                key: Key(subject.id.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) async {
                  await LearningModel.removeSubject(subject.id!);
                  _subjects.removeAt(index);
                  setState(() {
                    subject.isEnabled = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'LearningModel "${subject.subjectName}" deleted',
                      ),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () async {
                          await LearningModel.addSubject(subject);
                          _subjects.insert(index, subject);
                          setState(() {
                            subject.isEnabled = true;
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
                            Icon(Icons.book, size: 40, color: Colors.blue),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Text(
                                //   _formatTime(
                                //     subject.alarmTime ??
                                //         const TimeOfDay(hour: 0, minute: 0),
                                //   ),
                                //   style: const TextStyle(
                                //     fontSize: 24,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                                manjari(
                                  subject.subjectName ?? "Medicine",
                                  fontSize: 32,
                                ),
                                manjari(
                                  subject.studyDuration!,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            ),
                            const Spacer(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: subject.isEnabled
                                    ? const Color.fromARGB(255, 111, 190, 255)
                                    : const Color.fromARGB(255, 157, 211, 255),
                              ),
                              onPressed: () {
                                setState(() {
                                  subject.isEnabled = !subject.isEnabled;
                                });
                                LearningModel.setLearningEnabled(
                                  subject.id!,
                                  subject.isEnabled,
                                );
                              },
                              child: Text(subject.isEnabled ? 'Start' : 'Done'),
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
                                    subject.studyTime ??
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
                //   child: Icon(Icons.subject),
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
