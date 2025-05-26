import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskmate/models/learning.module.dart';
import 'package:taskmate/views/custom_app_bar.dart';
import 'package:taskmate/views/gradient_body.dart';

class AddLearningPage extends StatefulWidget {
  const AddLearningPage({super.key});

  @override
  State<AddLearningPage> createState() => _AddLearningPageState();
}

class _AddLearningPageState extends State<AddLearningPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(
        customTitle: 'Add Subject Session',
        isCenterTitle: true,
      ),
      body: SafeArea(
        child: TimeSelector(
          onAddingSubject: (subjectSession) async {
            // add subjectSession
            setState(() {
              Navigator.of(context).pop(true);
              // Subject.addSubject(subjectSession);
            });
          },
        ),
      ),
    );
  }
}

class TimeSelector extends StatefulWidget {
  final void Function(Subject) onAddingSubject;

  const TimeSelector({super.key, required this.onAddingSubject});

  @override
  State<TimeSelector> createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {
  int hour = DateTime.now().hour;
  int minute = DateTime.now().minute;
  late bool isAm;
  final TextEditingController _subjectNameController = TextEditingController();
  final TextEditingController _subjectDurationController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    isAm = hour < 12;
    hour = hour % 12;
  }

  @override
  void dispose() {
    _subjectNameController.dispose();
    _subjectDurationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return gradientBody(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Time Selection Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TimePickerColumn(
                        value: (hour - 1) % 12,
                        max: 12,
                        isHour: true,
                        onChanged: (val) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() => hour = (val % 12) + 1);
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(":", style: TextStyle(fontSize: 32)),
                      ),
                      TimePickerColumn(
                        value: minute,
                        max: 60,
                        onChanged: (val) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() => minute = val);
                          });
                        },
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

                  // Alarm Name Input
                  SizedBox(
                    width: 200,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _subjectNameController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Subject name is required';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Subject Name',
                              hintStyle: GoogleFonts.manjari(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: const Color.fromARGB(255, 0, 113, 170),
                              ),
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
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _subjectDurationController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Study duration is required';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Study Duration',
                              hintStyle: GoogleFonts.manjari(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: const Color.fromARGB(255, 0, 113, 170),
                              ),
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Done Button
            ElevatedButton(
              onPressed: _addAndScheduleSubjectSession,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Add Medicine',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
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

  // void _addAndScheduleSubjectSession() {
  //   final int hour24 = isAm
  //       ? (hour == 12 ? 0 : hour)
  //       : (hour == 12 ? 12 : hour + 12);

  //   final List<int> weekdays = [];
  //   for (int i = 0; i < selectedDays.length; i++) {
  //     if (selectedDays[i]) weekdays.add(i + 1); // 1 = Monday
  //   }

  //   final subject = SubjectModel(
  //     id: DateTime.now().millisecondsSinceEpoch,
  //     title: _subjectNameController.text.trim().isNotEmpty
  //         ? _subjectNameController.text.trim()
  //         : 'Alarm',
  //     alarmTime: TimeOfDay(hour: hour24, minute: minute),
  //     isEnabled: true,
  //     alarmWeekdays: weekdays,
  //   );

  //   widget.onAddingSubject(subject);
  // }

  void _addAndScheduleSubjectSession() {
    if (_formKey.currentState!.validate()) {
      // do nothing
    } else {
      return;
    }

    final subjectSession = Subject(
      id: DateTime.now().millisecondsSinceEpoch % 20000000,
      subjectName: _subjectNameController.text.trim().isNotEmpty
          ? _subjectNameController.text.trim()
          : 'Subject',
      studyDuration: _subjectDurationController.text.trim().isNotEmpty
          ? _subjectDurationController.text.trim()
          : 'Duration',
      studyTime: TimeOfDay(
        hour: isAm ? (hour == 12 ? 0 : hour) : (hour == 12 ? 12 : hour + 12),
        minute: minute,
      ),
      isEnabled: true,
    );

    Subject.addSubject(subjectSession);
    widget.onAddingSubject(subjectSession);
  }
}

class TimePickerColumn extends StatefulWidget {
  final int value;
  final int max;
  final bool isHour;
  final ValueChanged<int> onChanged;

  const TimePickerColumn({
    required this.value,
    required this.max,
    required this.onChanged,
    this.isHour = false,
    super.key,
  });

  @override
  State<TimePickerColumn> createState() => _TimePickerColumnState();
}

class _TimePickerColumnState extends State<TimePickerColumn> {
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(initialItem: widget.value);
  }

  void _scrollTo(int index) {
    _controller.animateToItem(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
    widget.onChanged(index);
  }

  @override
  void didUpdateWidget(covariant TimePickerColumn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.selectedItem) {
      _controller.jumpToItem(widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_up, size: 18),
          onPressed: () {
            final next = (widget.value - 1 + widget.max) % widget.max;
            _scrollTo(next);
          },
        ),
        SizedBox(
          height: 120,
          width: 60,
          child: ListWheelScrollView.useDelegate(
            itemExtent: 40,
            diameterRatio: 1.2,
            perspective: 0.005,
            // offAxisFraction: 0.8,
            physics: const FixedExtentScrollPhysics(),
            controller: _controller,
            onSelectedItemChanged: widget.onChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: widget.max,
              builder: (context, index) {
                final isSelected = index == widget.value;
                final display = widget.isHour
                    ? ((index % 12) + 1).toString().padLeft(2, '0')
                    : index.toString().padLeft(2, '0');
                return Center(
                  child: Text(
                    display,
                    style: TextStyle(
                      fontSize: isSelected ? 36 : 18,
                      color: isSelected ? Colors.black : Colors.black54,
                      fontWeight: FontWeight.bold,
                      shadows: isSelected
                          ? [
                              const Shadow(
                                blurRadius: 2,
                                color: Colors.black26,
                                offset: Offset(2, 2),
                              ),
                            ]
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, size: 18),
          onPressed: () {
            final next = (widget.value + 1) % widget.max;
            _scrollTo(next);
          },
        ),
      ],
    );
  }
}
