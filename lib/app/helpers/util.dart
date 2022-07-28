import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Helpers {
  static void setToast({required String message, int duration = 5}) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 40),
      duration: Duration(seconds: duration),
      content: Text(message),
    ));
  }

  static String stringGenerator({required int length}) {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  static AlertDialog showDialog({
    required BuildContext context,
    required String title,
    required String message,
    VoidCallback? cancelFunction,
    VoidCallback? function,
  }) {
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(message),
      actions: [
        cancelFunction != null
            ? TextButton(
                onPressed: () {
                  Get.back();
                  cancelFunction();
                },
                child: const Text("Cancel"))
            : const SizedBox(),
        TextButton(
            onPressed: () {
              Get.back();
              if (function != null) {
                function();
              }
            },
            child: const Text("Ok")),
      ],
    );
  }
}
