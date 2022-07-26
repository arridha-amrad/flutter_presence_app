import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/helpers/helpers.dart';

class AddEmployeeController extends GetxController {
  TextEditingController emailCon = TextEditingController();
  TextEditingController nipCon = TextEditingController();
  TextEditingController nameCon = TextEditingController();
  TextEditingController passwordConAdmin = TextEditingController();

  final _auth = FirebaseAuth.instance;

  final _authController = Get.put(AuthenticationController());
  final _employeeController = Get.put(EmployeeController());

  RxBool isEmailValid = false.obs;
  RxBool isNipFilled = false.obs;
  RxBool isNameFilled = false.obs;
  RxBool isLoading = false.obs;
  RxBool isPasswordFilled = false.obs;

  RxString errorText = "".obs;

  @override
  void onInit() {
    emailCon.addListener(() => isEmailValid.value = emailCon.text.isEmail);
    nipCon.addListener(() => isNipFilled.value = nipCon.text.isNotEmpty);
    nameCon.addListener(() => isNameFilled.value = nameCon.text.isNotEmpty);
    passwordConAdmin.addListener(
        () => isPasswordFilled.value = passwordConAdmin.text.isNotEmpty);
    super.onInit();
  }

  @override
  void onClose() {
    emailCon.dispose();
    nipCon.dispose();
    nameCon.dispose();
    super.onClose();
  }

  void _reset() {
    emailCon.clear();
    nipCon.clear();
    nameCon.clear();
    passwordConAdmin.clear();
    errorText.value = "";
  }

  Future<void> addEmployee() async {
    isLoading.value = true;
    final email = _auth.currentUser!.email!;
    final loginResponse = await _authController.login(
      email: email,
      password: passwordConAdmin.text,
    );
    if (loginResponse.getUserCredential == null) {
      errorText.value = "Verification password failed";
    } else {
      final response = await _authController.register(
        email: emailCon.text,
        password: "password",
      );
      if (response.getUserCredential == null) {
        Helpers.setToast(message: response.message!);
      } else {
        // close verification admin dialog
        Get.back();
        final user = response.getUserCredential!.user!;
        await _employeeController.saveEmployee(userId: user.uid, data: {
          "uid": user.uid,
          "nip": nipCon.text,
          "name": nameCon.text,
          "email": emailCon.text,
          "createdAt": DateTime.now().toIso8601String(),
          "isFirstLogin": true,
          "role": "employee",
          "avatarUrl":
              "https://firebasestorage.googleapis.com/v0/b/flutter-presence-081215.appspot.com/o/avatar%2Fprofil-pic_dummy.png?alt=media&token=ee884ffb-e798-4a48-a81d-ea2ab03afa5b",
        });
        await _authController.logout();
        final res = await _authController.login(
            email: email, password: passwordConAdmin.text);
        if (res.getUserCredential != null) {
          showDialog(
              context: Get.context!,
              builder: (context) => Helpers.showDialog(
                    context: Get.context!,
                    title: "New employee added",
                    message:
                        "We have sent an email to ${emailCon.text}. Please follow the instructions to verify the account.",
                    function: _reset,
                  ));
        }
      }
    }
    isLoading.value = false;
  }
}
