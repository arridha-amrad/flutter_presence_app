import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Helpers {
  static void setToast({required String message, int duration = 5}) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        duration: Duration(seconds: duration), content: Text(message)));
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
