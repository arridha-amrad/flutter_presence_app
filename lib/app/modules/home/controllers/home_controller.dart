import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:presence_app/app/routes/app_pages.dart';

class HomeController extends GetxController {
  TextEditingController passwordCon = TextEditingController();

  final _auth = FirebaseAuth.instance;
  final employee = FirebaseFirestore.instance.collection("employees");

  RxString email = "".obs;
  RxBool isFirstLogin = false.obs;
  RxBool isShowPassword = false.obs;
  RxBool isPasswordValid = false.obs;

  _setToast(String message) {
    return ScaffoldMessenger.of(Get.context!)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> updatePassword() async {
    final user = _auth.currentUser!;
    await employee.doc(user.uid).update({"isFirstLogin": false});
    await user.updatePassword(passwordCon.text);
    await _auth.signOut();
    await _auth.signInWithEmailAndPassword(
      email: user.email!,
      password: passwordCon.text,
    );
    _setToast("Password updated successfully");
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser() async {
    final uid = _auth.currentUser!.uid;
    return employee.doc(uid).get();
  }

  @override
  void onInit() async {
    passwordCon.addListener(() {
      // Minimum six characters, at least one letter, one number and one special character:
      RegExp regExp = RegExp(
          r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{6,}$");
      isPasswordValid.value = regExp.hasMatch(passwordCon.text);
    });
    super.onInit();
  }

  Future<void> logout() async {
    await _auth.signOut();
    Get.offNamed(Routes.LOGIN);
  }
}
