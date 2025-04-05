import 'package:flutter/material.dart';

enum SnackbarType { success, error }

class SnackBarUtils {
  static void showSnackbar({
    required BuildContext context,
    required String message,
    SnackbarType snackbarType = SnackbarType.error,
  }) {
    // Implement your snackbar display logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor:
            snackbarType == SnackbarType.error ? Colors.red : Colors.green,
        content: Text(
          message,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
