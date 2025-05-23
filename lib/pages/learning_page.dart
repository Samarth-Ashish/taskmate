import 'package:flutter/material.dart';

class LearningPage extends StatefulWidget {
  const LearningPage({super.key});

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Learning Page', style: TextStyle(fontSize: 24)));
  }
}
