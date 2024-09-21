import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Showalert extends GetxController {
  void showFlushbar(
      BuildContext context, IconData icon, String title, String message) {
    Flushbar(
      icon: Icon(icon, size: 32, color: Colors.white),
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      shouldIconPulse: false,
      title: title,
      message: message,
      borderRadius: BorderRadius.circular(8),
      margin: const EdgeInsets.fromLTRB(8, 20, 8, 0),
      barBlur: 10,
      backgroundColor: const Color.fromARGB(200, 30, 129, 176).withOpacity(0.5),
    ).show(context);
  }
}
