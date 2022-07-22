import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence_app/app/widgets/button_loading.dart';
import 'package:presence_app/app/widgets/text_input.dart';

import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  const UpdateProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = Get.arguments;
    controller.nipCon.text = user["nip"];
    controller.emailCon.text = user["email"];
    controller.nameCon.text = user["name"];
    return Scaffold(
        appBar: AppBar(
          title: const Text('Update Profile'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            const SizedBox(height: 12),
            TextInput(
              label: "Nip",
              controller: controller.nipCon,
              isReadOnly: true,
            ),
            TextInput(
              textInputType: TextInputType.emailAddress,
              label: "Email",
              controller: controller.emailCon,
              isReadOnly: true,
            ),
            TextInput(
              label: "Name",
              controller: controller.nameCon,
            ),
            Obx(() => ButtonLoading(
                  isLoading: controller.isLoading.value,
                  label: "Update",
                  function: controller.isLoading.isFalse &&
                          controller.isNameValid.isTrue
                      ? () => controller.updateProfile(userId: user["uid"])
                      : null,
                ))
          ],
        ));
  }
}
