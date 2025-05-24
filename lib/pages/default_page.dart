import 'package:flutter/material.dart';
import 'package:taskmate/pages/adders/profile_page.dart';
import 'package:taskmate/pages/adders/sleep_stats_page.dart';
import 'package:taskmate/views/custom_app_bar.dart';
import 'package:taskmate/views/gradient_body.dart';
import '../pages/home_page.dart';
import 'alarm_page.dart';
import '../pages/sleep_page.dart';
import '../pages/learning_page.dart';
import 'medicine_page.dart';
import 'adders/add_alarm_page.dart';
import 'adders/add_meds_page.dart';
import 'adders/add_learning_page.dart';

class DefaultNavPage extends StatefulWidget {
  const DefaultNavPage({super.key});

  @override
  State<DefaultNavPage> createState() => _DefaultNavPageState();
}

class _DefaultNavPageState extends State<DefaultNavPage> {
  int _selectedIndex = 0;

  final List<Widget> pages = [
    HomePage(),
    AlarmPage(),
    SleepPage(),
    MedicinePage(),
    LearningPage(),
  ];

  late final List<PreferredSizeWidget> _appBars;

  void _onTappingNavBarItem(int index) {
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
        // onTap: () async {
        //   final result = await Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (_) => AddAlarmPage()),
        //   );

        //   if (result == true && mounted) {
        //     // Reload alarms if we're in AlarmPage
        //     final state = context.findAncestorStateOfType<_AlarmPageState>();
        //     await state?._loadAlarms();
        //   }
        // },
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddAlarmPage()),
          );

          // if (result == true && _selectedIndex == 1 && mounted) {
          setState(() {
            _selectedIndex = 0; // or reload alarms if needed
            _selectedIndex = 1; // or reload alarms if needed
          }); // forces AlarmPage to rebuild
          // }
        },
      ),
      CustomAppBar(
        // pageToPush: SleepStatsPage(),
        addText: false,
        actionIcon: Icons.nightlight_round,
        customTitle: 'Sleep',
      ),
      CustomAppBar(
        pageToPush: AddMedsPage(),
        actionIcon: Icons.medication,
        customTitle: 'Medicine',
      ),
      CustomAppBar(
        pageToPush: AddLearningPage(),
        actionIcon: Icons.book,
        customTitle: 'Learning',
      ),
    ];
  }

  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBars[_selectedIndex],
      body: gradientBody(child: pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        currentIndex: _selectedIndex,
        onTap: _onTappingNavBarItem,
        selectedItemColor: Colors.blue,
        unselectedItemColor: const Color.fromARGB(137, 0, 0, 0),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.nightlight_round),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication_outlined),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: ''),
        ],
      ),
    );
  }
}
