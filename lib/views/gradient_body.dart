import 'package:flutter/material.dart';

Widget gradientBody({required Widget child}) {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFFA8DEFF), Color.fromARGB(255, 56, 179, 255)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
    ),
    child: child,
    // child: ConstrainedBox(
    //   constraints: BoxConstraints(
    //     minHeight: MediaQuery.of(context).size.height,
    //   ),
    //   child: child,
    // ),
  );
}
