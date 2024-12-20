import 'package:degree_verifier/Config/constants.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message, {int duration = 2, bool error = true}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      width: MediaQuery.of(context).size.width * 0.7, // Width of the SnackBar
      backgroundColor: Colors.white, // Background color of the SnackBar
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.black, width: 0.1),
      ),
      elevation: 10,
      content: Text(
        "${error ? "ERROR: " : ""}$message",
        style: TextStyle(color: error ? Colors.red : designColor),
        textAlign: TextAlign.center,
      ),
      duration: Duration(seconds: duration), // Set duration to 2 seconds
    ),
  );
}