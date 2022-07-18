import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/routes/app_pages.dart';

class LoginController extends GetxController {
  TextEditingController emailCon =
      TextEditingController(text: "dev.with.ari@gmail.com");
  TextEditingController passwordCon = TextEditingController(text: "password");

  final formKey = GlobalKey<FormState>();

  RxBool isEmailFilled = false.obs;
  RxBool isPasswordFilled = false.obs;
  RxBool isShowPassword = false.obs;

  RxString alertMessage = "".obs;

  String? validateEmail(String? val) {
    if (val != null) {
      if (!val.isEmail) return "Email is not valid";
    }
    return null;
  }

  String? validatePassword(String? val) {
    if (val != null) {
      if (val.isEmpty) return "Password is required";
    }
    return null;
  }

  @override
  void onInit() {
    emailCon.addListener(() => isEmailFilled.value = emailCon.text.isNotEmpty);
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

  void _setToast(String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 5),
    ));
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
              _setToast("Please check your email");
            },
            child: const Text("Resend")),
        TextButton(onPressed: () => Get.back(), child: const Text("Ok")),
      ],
    );
  }

  Future<void> login() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailCon.text, password: passwordCon.text);
      if (credential.user == null) return;
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
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _setToast("User not found");
      } else if (e.code == 'wrong-password') {
        _setToast("Invalid email and password");
      }
    }
  }
}
