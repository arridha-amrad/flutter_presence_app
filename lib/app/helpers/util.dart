import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Helpers {
  static void setToast({required String message, int duration = 5}) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
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
    VoidCallback? function,
  }) {
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(message),
      actions: [
        TextButton(
            onPressed: () {
              if (function != null) {
                function();
              }
              Get.back();
            },
            child: const Text("Ok")),
      ],
    );
  }
}
