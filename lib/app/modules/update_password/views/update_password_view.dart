import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence_app/app/widgets/button_loading.dart';
import 'package:presence_app/app/widgets/text_input_password.dart';

import '../controllers/update_password_controller.dart';

class UpdatePasswordView extends GetView<UpdatePasswordController> {
  const UpdatePasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Update Password'),
          centerTitle: true,
        ),
        body: Obx(() => ListView(
              padding: const EdgeInsets.all(12),
              children: [
                TextInputPassword(
                  errorText: controller.errorText.value,
                  label: "Old Password",
                  controller: controller.oldPassCon,
                ),
                TextInputPassword(
                  label: "New Password",
                  controller: controller.newPassCon,
                  isShowHelperText: true,
                ),
                const SizedBox(height: 12),
                ButtonLoading(
                  isLoading: controller.isLoading.value,
                  label: "Update",
                  function: controller.isLoading.isFalse &&
                          controller.isNewPassValid.isTrue
                      ? () => controller.updatePassword()
                      : null,
                )
              ],
            )));
  }
}
