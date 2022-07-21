import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEmployeeController extends GetxController {
  TextEditingController emailCon = TextEditingController();
  TextEditingController nipCon = TextEditingController();
  TextEditingController nameCon = TextEditingController();
  TextEditingController passwordConAdmin = TextEditingController();

  final CollectionReference _employees =
      FirebaseFirestore.instance.collection("employees");

  final _auth = FirebaseAuth.instance;

  final formKey = GlobalKey<FormState>();

  RxBool isEmailFilled = false.obs;
  RxBool isNipFilled = false.obs;
  RxBool isNameFilled = false.obs;
  RxBool isLoading = false.obs;
  RxBool isShowPasswordAdmin = false.obs;

  @override
  void onInit() {
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
    required User user,
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
              Get.back();
              _setToast("Please check your email at ${emailCon.text}");
              _resetTextField();
            },
            child: const Text("Ok")),
      ],
    );
  }

  Future<UserCredential?> _registerNewEmployee() async {
    UserCredential? userCredential;
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
          email: emailCon.text, password: "password");
      // send an email for new account-verification
      await credential.user!.sendEmailVerification();
      userCredential = credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        _setToast("Email has been registered");
      }
      if (e.code == "invalid-email") {
        _setToast("Email is not valid");
      }
    } catch (e) {
      print("========================== error code : $e");
    }
    return userCredential;
  }

  Future<void> _storeNewEmployeeData(String uid) async {
    await _employees.doc(uid).set({
      "uid": uid,
      "nip": nipCon.text,
      "name": nameCon.text,
      "email": emailCon.text,
      "createdAt": DateTime.now().toIso8601String(),
      "isFirstLogin": true,
      "role": "employee",
    });
  }

  Future<UserCredential?> _login([String? email]) async {
    UserCredential? credential;
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email ?? _auth.currentUser!.email!,
        password: passwordConAdmin.text,
      );
      credential = credential;
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == "wrong-password") {
        _setToast("Invalid password");
      }
    } catch (e) {
      print(e);
    }
    return credential;
  }

  Future<void> addEmployee() async {
    isLoading.value = true;
    final email = _auth.currentUser!.email;
    try {
      final credential = await _login();
      if (credential == null) return;
      final userCredential = await _registerNewEmployee();
      if (userCredential == null) return;
      await _storeNewEmployeeData(userCredential.user!.uid);
      await _auth.signOut();
      await _login(email);
      showDialog(
          context: Get.context!,
          builder: (context) => _setAlertdialog(
                context: Get.context!,
                title: "Almost Done!",
                message:
                    "We have sent an email to ${emailCon.text}. Please follow the instructions to verify the account.",
                user: userCredential.user!,
              ));
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
