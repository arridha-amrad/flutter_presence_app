import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:presence_app/app/helpers/helpers.dart';
import 'package:presence_app/app/helpers/storage_controller.dart';

class UpdateProfileController extends GetxController {
  TextEditingController nipCon = TextEditingController();
  TextEditingController nameCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();

  final _employeeController = Get.put(EmployeeController());
  final _storageController = Get.put(StorageController());

  XFile? choosenPhoto;
  bool isLoadingUploadAvatar = false;
  bool isPickingImage = false;

  final user = Get.arguments;

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

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    choosenPhoto = image;
    isPickingImage = true;
    update();
  }

  Future<void> updateAvatar() async {
    isLoadingUploadAvatar = true;
    update();
    if (choosenPhoto == null) return;
    final url = await _storageController.store(
      xFile: choosenPhoto!,
      location: StorageFolder.avatar,
    );
    await _storageController.delete(
      url: user["avatarUrl"],
      location: StorageFolder.avatar,
    );
    await _employeeController.updateEmployee(
      data: {"avatarUrl": url},
      userId: user["uid"],
    );
    Helpers.setToast(message: "Avatar updated successfully");
    isLoadingUploadAvatar = false;
    isPickingImage = false;
    update();
  }
}
