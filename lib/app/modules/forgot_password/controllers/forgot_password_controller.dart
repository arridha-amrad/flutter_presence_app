import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  TextEditingController emailCon = TextEditingController();

  RxBool isEmailValid = false.obs;
  RxBool isLoading = false.obs;

  final _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    emailCon.addListener(() => isEmailValid.value = emailCon.text.isEmail);
    super.onInit();
  }

  @override
  void onClose() {
    emailCon.dispose();
    super.onClose();
  }

  _setToast(String message, [int duration = 5]) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: duration),
    ));
  }

  Future<void> sendResetPasswordRequest() async {
    isLoading.value = true;
    try {
      await _auth.sendPasswordResetEmail(email: emailCon.text);
      showDialog(
          context: Get.context!,
          builder: (context) => AlertDialog(
                title: const Text(
                  "Request submitted!",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: Text(
                    "An email has been sent to ${emailCon.text}. Please follow the instructions to reset your password."),
                actions: [
                  TextButton(
                      onPressed: () {
                        Get.back();
                        Get.back();
                      },
                      child: const Text("Ok"))
                ],
              ));
    } on FirebaseAuthException catch (e) {
      print("================= Firebase auth exception : ${e.code}");
      if (e.code == 'user-not-found') {
        _setToast("Email not registered");
      }
    } catch (e) {
      print("error : $e");
    } finally {
      isLoading.value = false;
    }
  }
}
