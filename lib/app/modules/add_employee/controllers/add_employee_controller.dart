import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEmployeeController extends GetxController {
  TextEditingController emailCon = TextEditingController();
  TextEditingController nipCon = TextEditingController();
  TextEditingController nameCon = TextEditingController();

  final CollectionReference _employees =
      FirebaseFirestore.instance.collection("employees");

  final formKey = GlobalKey<FormState>();

  RxBool isEmailFilled = false.obs;
  RxBool isNipFilled = false.obs;
  RxBool isNameFilled = false.obs;

  @override
  void onInit() {
    print("Hello World");
    emailCon.addListener(() => isEmailFilled.value = emailCon.text.isNotEmpty);
    nipCon.addListener(() => isNipFilled.value = nipCon.text.isNotEmpty);
    nameCon.addListener(() => isNameFilled.value = nameCon.text.isNotEmpty);
    super.onInit();
  }

  @override
  void onClose() {
    emailCon.dispose();
    nipCon.dispose();
    nameCon.dispose();
    super.onClose();
  }

  String? validateEmail(String? val) {
    if (val != null) {
      if (!val.isEmail) return "Email is not valid";
    }
    return null;
  }

  String? validateNip(String? val) {
    if (val != null) {
      if (val.isEmpty) return "Nip is required";
    }
    return null;
  }

  String? validateName(String? val) {
    if (val != null) {
      if (val.isEmpty) return "Name is required";
    }
    return null;
  }

  void _setToast(String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 5),
    ));
  }

  void _resetTextField() {
    emailCon.clear();
    nipCon.clear();
    nameCon.clear();
  }

  AlertDialog _setAlertdialog({
    required BuildContext context,
    required String title,
    required String message,
    // required User user,
  }) {
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(message),
      actions: [
        TextButton(
            onPressed: () {
              // user.sendEmailVerification();
              Get.back();
              _resetTextField();
              _setToast("Please check your email");
            },
            child: const Text("Resend")),
        TextButton(
            onPressed: () {
              Get.back();
              _resetTextField();
              _setToast("Please check your email");
            },
            child: const Text("Ok")),
      ],
    );
  }

  Future<void> register() async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailCon.text,
        password: "password",
      );
      if (credential.user == null) return;
      await _employees.doc(credential.user!.uid).set({
        "uid": credential.user!.uid,
        "nip": nipCon.text,
        "name": nameCon.text,
        "email": emailCon.text,
        "createdAt": DateTime.now(),
        "isFirstLogin": true,
      });
      await credential.user!.sendEmailVerification();
      showDialog(
          context: Get.context!,
          builder: (context) => _setAlertdialog(
                context: Get.context!,
                title: "Almost Done!",
                message:
                    "We have sent you an email to verify your account. Please follow the instructions.",
                // user: credential.user!,
              ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _setToast("Email has been registered");
      }
    } catch (e) {
      print(e);
    }
  }
}
