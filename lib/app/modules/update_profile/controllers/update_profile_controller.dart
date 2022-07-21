import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateProfileController extends GetxController {
  TextEditingController nipCon = TextEditingController();
  TextEditingController nameCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isNameValid = false.obs;

  final employees = FirebaseFirestore.instance;

  @override
  void onInit() {
    nameCon.addListener(() => isNameValid.value = nameCon.text.isNotEmpty);
    super.onInit();
  }

  @override
  void onClose() {
    nipCon.dispose();
    nameCon.dispose();
    emailCon.dispose();
    super.onClose();
  }

  void _setToast({required String message, int? duration = 5}) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        duration: Duration(seconds: duration!), content: Text(message)));
  }

  Future<void> updateProfile({required String userId}) async {
    isLoading.value = true;
    try {
      await employees
          .collection("employees")
          .doc(userId)
          .update({"name": nameCon.text});
      _setToast(message: "Profile updated successfully");
      Get.back();
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
