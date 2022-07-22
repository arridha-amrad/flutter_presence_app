import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/constant.dart';
import 'package:presence_app/app/helpers/helpers.dart';

class UpdatePasswordController extends GetxController {
  TextEditingController oldPassCon = TextEditingController();
  TextEditingController newPassCon = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _authController = Get.put(AuthenticationController());

  final RxBool isLoading = false.obs;
  RxBool isNewPassValid = false.obs;
  RxString errorText = "".obs;

  @override
  void onInit() {
    newPassCon.addListener(() {
      isNewPassValid.value = passwordRegex.hasMatch(newPassCon.text);
    });
    super.onInit();
  }

  @override
  void onClose() {
    oldPassCon.dispose();
    newPassCon.dispose();
    super.onClose();
  }

  Future<void> updatePassword() async {
    isLoading.value = true;
    final loginResponse = await _authController.login(
      email: _auth.currentUser!.email!,
      password: oldPassCon.text,
    );
    if (loginResponse.getUserCredential == null) {
      errorText.value = "Wrong password";
    } else {
      final credential = loginResponse.getUserCredential!;
      await credential.user!.updatePassword(newPassCon.text);
      Helpers.setToast(message: "Password updated successfully");
      Get.back();
    }
    isLoading.value = false;
  }
}
