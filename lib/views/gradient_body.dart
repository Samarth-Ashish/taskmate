// import 'package:flutter/material.dart';

// class GradientScaffold extends StatelessWidget {
//   final Widget body;
//   final PreferredSizeWidget? appBar;
//   final Widget? floatingActionButton;
//   final List<Widget>? persistentFooterButtons;

//   const GradientScaffold({
//     super.key,
//     required this.body,
//     this.appBar,
//     this.floatingActionButton,
//     this.persistentFooterButtons,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: appBar,
//       floatingActionButton: floatingActionButton,
//       persistentFooterButtons: persistentFooterButtons,
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFF6D0EB5), Color(0xFF4059F1)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: body,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

Container gradientBody({required Widget child}) {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFFA8DEFF), Color.fromARGB(255, 56, 179, 255)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
    ),
    child: child,
  );
}
