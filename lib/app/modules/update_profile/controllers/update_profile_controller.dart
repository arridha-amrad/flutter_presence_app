import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/helpers/helpers.dart';

class UpdateProfileController extends GetxController {
  TextEditingController nipCon = TextEditingController();
  TextEditingController nameCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();

  final _employeeController = Get.put(EmployeeController());

  RxBool isLoading = false.obs;
  RxBool isNameValid = false.obs;

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

  Future<void> updateProfile({required String userId}) async {
    isLoading.value = true;
    final res = await _employeeController
        .updateEmployee(userId: userId, data: {"name": nameCon.text});
    Helpers.setToast(message: res ?? "Profile updated successfully");
    isLoading.value = false;
  }
}
