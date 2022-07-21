import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/helpers/set_toast.dart';

class UpdatePasswordController extends GetxController {
  TextEditingController oldPassCon = TextEditingController();
  TextEditingController newPassCon = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxBool isOldPasswordCorrect = true.obs;
  RxBool isLoading = false.obs;
  RxBool isNewPassValid = false.obs;

  @override
  void onInit() {
    newPassCon.addListener(() {
      RegExp regExp = RegExp(
          r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{6,}$");
      isNewPassValid.value = regExp.hasMatch(newPassCon.text);
    });
    super.onInit();
  }

  @override
  void onClose() {
    oldPassCon.dispose();
    newPassCon.dispose();
    super.onClose();
  }

  // Helpers.setToast(message: "Toast set");

  Future<UserCredential?> _login() async {
    UserCredential? userCredential;
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: _auth.currentUser!.email!, password: oldPassCon.text);
      userCredential = credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == "wrong-password") {
        Helpers.setToast(message: "Wrong password");
        isOldPasswordCorrect.value = false;
      }
    } catch (e) {
      print(e);
    }
    return userCredential;
  }

  Future<void> updatePassword() async {
    isLoading.value = true;
    try {
      final credential = await _login();
      if (credential == null) return;
      await credential.user!.updatePassword(newPassCon.text);
      Helpers.setToast(message: "Password updated successfully");
      Get.back();
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
