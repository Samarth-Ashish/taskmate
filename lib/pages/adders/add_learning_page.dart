import 'package:flutter/material.dart';

class AddLearningPage extends StatefulWidget {
  const AddLearningPage({super.key});

  @override
  State<AddLearningPage> createState() => _AddLearningPageState();
}

class _AddLearningPageState extends State<AddLearningPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Learning'),
      ),
    );
  }
}
