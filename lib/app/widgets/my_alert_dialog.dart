import 'package:flutter/material.dart';
import 'package:get/get.dart';

AlertDialog setAlertdialog({
  required BuildContext context,
  required String title,
  required String message,
}) {
  return AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      TextButton(onPressed: () => Get.back(), child: const Text("Ok")),
    ],
  );
}
