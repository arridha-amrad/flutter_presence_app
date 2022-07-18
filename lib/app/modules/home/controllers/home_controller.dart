import 'dart:convert';

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
    if (_auth.currentUser != null) {
      await _auth.currentUser!.updatePassword(passwordCon.text);
      await employee
          .doc(_auth.currentUser!.uid)
          .update({"isFirstLogin": false});
      _setToast("Password updated successfully");
    }
  }

  @override
  void onInit() async {
    passwordCon.addListener(() {
      // Minimum six characters, at least one letter, one number and one special character:
      RegExp regExp = RegExp(
          r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{6,}$");
      isPasswordValid.value = regExp.hasMatch(passwordCon.text);
    });
    if (_auth.currentUser != null) {
      email.value = _auth.currentUser!.email!;
    }
    final isInit = Get.parameters["initLogin"];
    print(isInit);
    final snapshot = await employee.doc(_auth.currentUser!.uid).get();
    final user = snapshot.data();
    print("==================== user : $user");
    if (user != null && user["isFirstLogin"]) {
      Future.delayed(
          const Duration(milliseconds: 500),
          () => showDialog(
              context: Get.context!,
              builder: (context) => Obx(() => AlertDialog(
                    title: const Text(
                      "Welcome to the App",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: SizedBox(
                      height: MediaQuery.of(context).size.height / 3,
                      child: Column(
                        children: [
                          const Text(
                            "We notice this is your first login. Please update your password",
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 17.0),
                          TextFormField(
                            controller: passwordCon,
                            obscureText: !isShowPassword.value,
                            decoration: const InputDecoration(
                                hintText: "Password",
                                border: UnderlineInputBorder()),
                          ),
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            value: isShowPassword.value,
                            dense: true,
                            onChanged: (val) {
                              if (val != null) {
                                isShowPassword.value = val;
                              }
                            },
                            title: const Text("Show Password"),
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                          const SizedBox(height: 12.0),
                        ],
                      ),
                    ),
                    actions: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: isPasswordValid.value
                                ? () {
                                    updatePassword();
                                    Get.back();
                                  }
                                : null,
                            child: const Text("Update Password")),
                      )
                    ],
                  ))));
    }
    super.onInit();
  }

  Future<void> logout() async {
    await _auth.signOut();
    Get.offNamed(Routes.LOGIN);
  }
}
