import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Helpers {
  static void setToast({required String message, int duration = 5}) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        duration: Duration(seconds: duration), content: Text(message)));
  }
}
