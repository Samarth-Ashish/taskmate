import 'package:flutter/material.dart';

class AddMedsPage extends StatefulWidget {
  const AddMedsPage({super.key});

  @override
  State<AddMedsPage> createState() => _AddMedsPageState();
}

class _AddMedsPageState extends State<AddMedsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Meds'),
      ),
    );
  }
}
