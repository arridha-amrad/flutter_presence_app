import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/constant.dart';
import 'package:presence_app/app/helpers/helpers.dart';

import 'package:presence_app/app/routes/app_pages.dart';

class HomeController extends GetxController {
  TextEditingController passwordCon = TextEditingController();

  final _auth = FirebaseAuth.instance;
  final employee = FirebaseFirestore.instance.collection("employees");

  final _authController = Get.put(AuthenticationController());
  final _employeeController = Get.put(EmployeeController());

  RxBool isFirstLogin = false.obs;
  RxBool isShowPassword = false.obs;
  RxBool isPasswordValid = false.obs;
  RxBool isLoading = false.obs;

  Future<void> updatePassword() async {
    isLoading.value = true;
    final user = _auth.currentUser!;
    await _employeeController
        .updateEmployee(userId: user.uid, data: {"isFirstLogin": false});
    await user.updatePassword(passwordCon.text);
    await _authController.logout();
    await _authController.login(email: user.email!, password: passwordCon.text);
    isLoading.value = false;
    Helpers.setToast(message: "Password updated successfully");
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getEmployee() async* {
    yield* _employeeController.getEmployee(_auth.currentUser!.uid);
  }

  @override
  void onInit() async {
    passwordCon.addListener(() {
      isPasswordValid.value = passwordRegex.hasMatch(passwordCon.text);
    });
    super.onInit();
  }

  Future<void> logout() async {
    await _auth.signOut();
    Get.offNamed(Routes.LOGIN);
  }
}
