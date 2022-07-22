import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/constant.dart';
import 'package:presence_app/app/helpers/alert.dart';
import 'package:presence_app/app/helpers/firebase_auth/authentication_firebase.dart';
import 'package:presence_app/app/helpers/firebase_firestore/employee_firestore.dart';

import 'package:presence_app/app/routes/app_pages.dart';

class HomeController extends GetxController {
  TextEditingController passwordCon = TextEditingController();

  final _auth = FirebaseAuth.instance;
  final employee = FirebaseFirestore.instance.collection("employees");

  RxBool isFirstLogin = false.obs;
  RxBool isShowPassword = false.obs;
  RxBool isPasswordValid = false.obs;
  RxBool isLoading = false.obs;

  Future<void> updatePassword() async {
    isLoading.value = true;
    final user = _auth.currentUser!;
    await EmployeeFireStore.update(
        userId: user.uid, data: {"isFirstLogin": false});
    await user.updatePassword(passwordCon.text);
    await AuthenticationFirebase.logout();
    await AuthenticationFirebase.login(
        email: user.email!, password: passwordCon.text);
    isLoading.value = false;
    Helpers.setToast(message: "Password updated successfully");
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser() async {
    final uid = _auth.currentUser!.uid;
    return employee.doc(uid).get();
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
