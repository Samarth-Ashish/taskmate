import 'package:flutter/material.dart';

class SnackbarUtil {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showSnackbar(
    String message, {
    Duration duration = const Duration(seconds: 2),
    Color backgroundColor = Colors.black,
  }) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      duration: duration,
      backgroundColor: backgroundColor,
    );

    scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }

  static void showErrorSnackbar(
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    showSnackbar(message, duration: duration, backgroundColor: Colors.red);
  }

  static void showSuccessSnackbar(
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    showSnackbar(
      message,
      duration: duration,
      backgroundColor: Color(0xff96DBF8),
    );
  }
}
