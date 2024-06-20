import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message, Color? color) {
  // hide current snackbar

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
}

void showSnackBarError(BuildContext context, String message) {
  showSnackBar(context, message, Colors.red);
}

void showSnackBarSuccess(BuildContext context, String message) {
  showSnackBar(context, message, Colors.green);
}

void showSnackBarInfo(BuildContext context, String message) {
  showSnackBar(context, message, Colors.blue);
}

void showSnackBarWarning(BuildContext context, String message) {
  showSnackBar(context, message, Colors.orange);
}
