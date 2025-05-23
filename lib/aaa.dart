// //=== Model (models/home_model.dart) ===


// class Summary {
//   final int medications;
//   final String sleepTime;
//   final String learningTime;

//   Summary({required this.medications, required this.sleepTime, required this.learningTime});
// }

// class Alarm {
//   final String label;
//   final String time;
//   final bool repeatsDaily;

//   Alarm({required this.label, required this.time, this.repeatsDaily = true});
// }


// //=== Controller (controllers/home_controller.dart) ===
// import '../models/home_model.dart';

// class HomeController {
//   Alarm alarm = Alarm(label: "Wake Up", time: "6:30 AM");
//   Summary summary = Summary(medications: 2, sleepTime: "10:00 PM to 6:00 AM", learningTime: "1 hour scheduled");
//   List<Task> quickActions = [
//     Task(title: "Take Vit–D", time: "8 AM"),
//     Task(title: "Study Math – 45 mins"),
//     Task(title: "Prepare for bed", time: "by 9:30 PM"),
//   ];

//   List<Task> get ongoingTasks => [quickActions[0]];

//   void markTaskCompleted(int index) {
//     quickActions[index] = Task(
//       title: quickActions[index].title,
//       time: quickActions[index].time,
//       isCompleted: true,
//     );
//   }
// }


// //=== View (views/home_page.dart) ===
// import 'package:flutter/material.dart';
// import '../controllers/home_controller.dart';
// import '../models/home_model.dart';

// class HomePage extends StatelessWidget {
//   final HomeController controller = HomeController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.lightBlue[100],
//       bottomNavigationBar: BottomNavigationBar(
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
//           BottomNavigationBarItem(icon: Icon(Icons.alarm), label: ''),
//           BottomNavigationBarItem(icon: Icon(Icons.nightlight_round), label: ''),
//           BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: ''),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
//         ],
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: const [
//                   Text('Home', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Cursive')),
//                   Icon(Icons.person)
//                 ],
//               ),
//               const SizedBox(height: 20),
//               _sectionTitle(Icons.alarm, 'Next Alarm'),
//               _alarmCard(controller.alarm),
//               const SizedBox(height: 16),
//               _sectionTitle(Icons.list, "Today's Summary"),
//               _summaryCard(controller.summary),
//               const SizedBox(height: 16),
//               _sectionTitle(Icons.add, 'Quick Actions'),
//               _quickActions(controller),
//               const SizedBox(height: 16),
//               _sectionTitle(Icons.check_circle, 'Ongoing Taks'),
//               _ongoingTasks(controller),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _sectionTitle(IconData icon, String title) {
//     return Row(
//       children: [
//         Icon(icon),
//         const SizedBox(width: 8),
//         Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//       ],
//     );
//   }

//   Widget _alarmCard(Alarm alarm) {
//     return Card(
//       child: ListTile(
//         title: Text(alarm.label),
//         subtitle: Text('Repeats Daily'),
//         trailing: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(alarm.time),
//             Text('Edit', style: TextStyle(color: Colors.blue, fontSize: 12))
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _summaryCard(Summary summary) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Medications: ${summary.medications} reminders'),
//             Text('Sleep: ${summary.sleepTime}'),
//             Text('Learning: ${summary.learningTime}'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _quickActions(HomeController controller) {
//     return Column(
//       children: controller.quickActions.map((task) {
//         return Card(
//           child: ListTile(
//             title: Text('${task.title} at ${task.time ?? ''}'),
//             trailing: task.isCompleted
//                 ? const Text('Marked')
//                 : TextButton(
//                     onPressed: () {},
//                     child: Text(task.title.contains('Study') ? 'Start Timer' : 'Mark Taken'),
//                   ),
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Widget _ongoingTasks(HomeController controller) {
//     return Column(
//       children: controller.ongoingTasks.map((task) {
//         return Card(
//           child: ListTile(
//             title: Text('${task.title} at ${task.time ?? ''}'),
//           ),
//         );
//       }).toList(),
//     );
//   }
// }
