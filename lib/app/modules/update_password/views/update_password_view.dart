import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_password_controller.dart';

class UpdatePasswordView extends GetView<UpdatePasswordController> {
  const UpdatePasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('UpdatePasswordView'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            const SizedBox(height: 12),
            TextFormField(
              obscureText: true,
              controller: controller.oldPassCon,
              decoration: const InputDecoration(
                  labelText: "Old Password", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextFormField(
              obscureText: true,
              controller: controller.newPassCon,
              decoration: const InputDecoration(
                  helperMaxLines: 5,
                  helperText:
                      "Password requires minimum six characters, at least one letter, one number and one special character.",
                  labelText: "New Password",
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            Obx(() => ElevatedButton(
                onPressed: controller.isLoading.isFalse &&
                        controller.isNewPassValid.isTrue
                    ? () => controller.updatePassword()
                    : null,
                child: const Text("Update")))
          ],
        ));
  }
}
