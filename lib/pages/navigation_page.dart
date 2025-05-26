import 'package:flutter/material.dart';
import 'package:taskmate/views/custom_app_bar.dart';
import 'package:taskmate/views/gradient_body.dart';
import 'main_pages/home_page.dart';
import 'main_pages/alarm_page.dart';
import 'main_pages/sleep_page.dart';
import 'main_pages/learning_page.dart';
import 'main_pages/medicine_page.dart';
import 'adders/add_alarm_page.dart';
import 'adders/add_meds_page.dart';
import 'adders/add_learning_page.dart';

class DefaultNavPage extends StatefulWidget {
  const DefaultNavPage({super.key});

  @override
  State<DefaultNavPage> createState() => _DefaultNavPageState();
}

final GlobalKey<HomePageState> _homePageKey = GlobalKey<HomePageState>();
final GlobalKey<AlarmPageState> _alarmPageKey = GlobalKey<AlarmPageState>();
final GlobalKey<MedicinePageState> _medicinePageKey =
    GlobalKey<MedicinePageState>();
final GlobalKey<LearningPageState> _learningPageKey =
    GlobalKey<LearningPageState>();

class _DefaultNavPageState extends State<DefaultNavPage> {
  int _selectedIndex = 0;

  final List<Widget> pages = [
    HomePage(key: _homePageKey),
    AlarmPage(key: _alarmPageKey),
    SleepPage(),
    MedicinePage(key: _medicinePageKey),
    LearningPage(key: _learningPageKey),
  ];

  late final List<PreferredSizeWidget> _appBars;

  void _onTappingNavBarItem(int index) {
    if (index == 0) {
      _homePageKey.currentState?.refresh();
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _appBars = [
      CustomAppBar(
        // pageToPush: ProfilePage(),
        addText: false,
        actionIcon: Icons.person,
        customTitle: 'Home',
      ),
      CustomAppBar(
        pageToPush: AddAlarmPage(),
        actionIcon: Icons.alarm_add,
        customTitle: 'Alarms',
        // isCenterTitle: true,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddAlarmPage()),
          ).then((_) {
            _alarmPageKey.currentState?.loadAlarms();
          });
        },
      ),
      CustomAppBar(
        // pageToPush: SleepStatsPage(),
        addText: false,
        actionIcon: Icons.nightlight_round,
        customTitle: 'Sleep',
      ),
      CustomAppBar(
        pageToPush: AddMedicinesPage(),
        actionIcon: Icons.medication,
        customTitle: 'Medicine',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMedicinesPage()),
          ).then((_) {
            _medicinePageKey.currentState?.loadMedicines();
          });
        },
      ),
      CustomAppBar(
        pageToPush: AddLearningPage(),
        actionIcon: Icons.book,
        customTitle: 'Learning',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddLearningPage()),
          ).then((_) {
            _learningPageKey.currentState?.loadSubjects();
          });
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('________Building DefaultNavPageState________');
    return Scaffold(
      appBar: _appBars[_selectedIndex],
      body: gradientBody(child: pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 112, 191, 255),
        elevation: 0,
        currentIndex: _selectedIndex,
        onTap: _onTappingNavBarItem,
        selectedItemColor: const Color.fromARGB(255, 0, 116, 211),
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home', //
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            label: 'Alarms', //
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.nightlight_round),
            label: 'Sleep',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication_outlined),
            label: 'Medicine',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Learning',
          ),
        ],
      ),
    );
  }
}
