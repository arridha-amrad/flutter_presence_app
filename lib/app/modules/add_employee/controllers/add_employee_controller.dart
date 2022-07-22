import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/helpers/alert.dart';
import 'package:presence_app/app/helpers/firebase_auth/authentication_firebase.dart';
import 'package:presence_app/app/helpers/firebase_firestore/employee_firestore.dart';

class AddEmployeeController extends GetxController {
  TextEditingController emailCon = TextEditingController();
  TextEditingController nipCon = TextEditingController();
  TextEditingController nameCon = TextEditingController();
  TextEditingController passwordConAdmin = TextEditingController();

  final _auth = FirebaseAuth.instance;

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
    final loginResponse = await AuthenticationFirebase.login(
      email: email,
      password: passwordConAdmin.text,
    );
    if (loginResponse.getUserCredential == null) {
      errorText.value = "Verification password failed";
    } else {
      final response = await AuthenticationFirebase.register(
        email: emailCon.text,
        password: "password",
      );
      if (response.getUserCredential == null) {
        Helpers.setToast(message: response.message!);
      } else {
        // close verification admin dialog
        Get.back();
        final user = response.getUserCredential!.user!;
        await EmployeeFireStore.save(userId: user.uid, data: {
          "uid": user.uid,
          "nip": nipCon.text,
          "name": nameCon.text,
          "email": emailCon.text,
          "createdAt": DateTime.now().toIso8601String(),
          "isFirstLogin": true,
          "role": "employee",
        });
        await AuthenticationFirebase.logout();
        final res = await AuthenticationFirebase.login(
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
