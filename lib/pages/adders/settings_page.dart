import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmate/models/alarm.module.dart';
import 'package:taskmate/models/medicine.module.dart';
import 'package:taskmate/models/learning.module.dart';
import 'package:taskmate/utils/snackbar_utils.dart';
import 'package:taskmate/views/custom_app_bar.dart';
import 'package:taskmate/views/gradient_body.dart';
import 'package:taskmate/views/texts.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isSoundEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSoundSetting();
  }

  Future<void> _loadSoundSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSoundEnabled = prefs.getBool('soundEnabled') ?? true;
    });
  }

  Future<void> _toggleSound(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('soundEnabled', value);
    setState(() {
      _isSoundEnabled = value;
      Alarm.syncAlarmsWithSystem();
      Medicine.syncMedicinesWithSystem();
      Subject.syncSubjectWithSystem();
    });
  }

  Future<void> _resetAllData() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 116, 216, 255),
        title: manjari('Reset All Data ?', fontSize: 22),
        content: manjari(
          'Are you sure you want to erase all alarms, medicines, and settings?',
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      Alarm.removeAllAlarms();
      Medicine.removeAllMedicines();
      Subject.removeAllSubjects();
      await prefs.clear();

      SnackbarUtil.showSnackbar('All data reset successfully');

      // setState(() {
      //   _isSoundEnabled = true;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(customTitle: 'Settings', isCenterTitle: true),
      body: SafeArea(
        child: gradientBody(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ListTile(
                leading: const Icon(
                  Icons.volume_up,
                  color: Color.fromARGB(255, 0, 116, 211),
                ),
                title: mada('Notification Sound', fontSize: 22),
                trailing: Switch(
                  value: _isSoundEnabled,
                  onChanged: _toggleSound,
                  activeColor: Color.fromARGB(255, 113, 186, 243),
                  activeTrackColor: Color(0xFF1776BF),
                  inactiveTrackColor: Color.fromARGB(0, 134, 209, 255),
                ),
              ),
              // const Divider(),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: mada(
                  'Reset All Data',
                  fontSize: 22,
                  color: const Color.fromARGB(255, 221, 85, 75),
                ),
                onTap: _resetAllData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
