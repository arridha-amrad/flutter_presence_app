import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/helpers/helpers.dart';

import 'package:presence_app/app/routes/app_pages.dart';

class LoginController extends GetxController {
  TextEditingController emailCon = TextEditingController();
  TextEditingController passwordCon = TextEditingController();

  final _authController = Get.put(AuthenticationController());

  RxBool isEmailFilled = false.obs;
  RxBool isPasswordFilled = false.obs;

  @override
  void onInit() {
    emailCon.addListener(() => isEmailFilled.value = emailCon.text.isEmail);
    passwordCon.addListener(
        () => isPasswordFilled.value = passwordCon.text.isNotEmpty);
    super.onInit();
  }

  @override
  void onClose() {
    emailCon.dispose();
    passwordCon.dispose();
    super.onClose();
  }

  AlertDialog _setAlertdialog({
    required BuildContext context,
    required String title,
    required String message,
    required User user,
  }) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
            onPressed: () {
              user.sendEmailVerification();
              Get.back();
              Helpers.setToast(
                  message: "Please check your inbox at ${user.email}",
                  duration: 10);
            },
            child: const Text("Resend")),
        TextButton(onPressed: () => Get.back(), child: const Text("Ok")),
      ],
    );
  }

  Future<void> login() async {
    try {
      final res = await _authController.login(
          email: emailCon.text, password: passwordCon.text);
      if (res.getUserCredential == null) {
        Helpers.setToast(message: res.message!);
        return;
      }
      final credential = res.getUserCredential!;
      if (!credential.user!.emailVerified) {
        showDialog(
            context: Get.context!,
            builder: (context) => _setAlertdialog(
                user: credential.user!,
                context: context,
                title: "Verification Required",
                message:
                    "You need to verify your email before using this app."));
      } else {
        Get.offNamed(Routes.HOME);
      }
    } catch (e) {
      print(e);
    }
  }
}
