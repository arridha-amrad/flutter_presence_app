import 'package:flutter/material.dart';

import 'package:get/get.dart';

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
            TextFormField(
              readOnly: true,
              controller: controller.nipCon,
              decoration: const InputDecoration(
                  labelText: "Nip", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextFormField(
              readOnly: true,
              controller: controller.emailCon,
              decoration: const InputDecoration(
                  labelText: "Email", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: controller.nameCon,
              decoration: const InputDecoration(
                  labelText: "Name", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            Obx(() => ElevatedButton(
                onPressed: controller.isLoading.isFalse &&
                        controller.isNameValid.isTrue
                    ? () => controller.updateProfile(userId: user["uid"])
                    : null,
                child: Text(
                    controller.isLoading.isTrue ? "Loading..." : "Update")))
          ],
        ));
  }
}
