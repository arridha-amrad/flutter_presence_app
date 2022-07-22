import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/modules/home/controllers/home_controller.dart';
import 'package:presence_app/app/widgets/button_loading.dart';
import 'package:presence_app/app/widgets/text_input_password.dart';

showUpdatePasswordDialog(HomeController controller) {
  return Future.delayed(
      Duration.zero,
      () => showDialog(
          barrierDismissible: false,
          context: Get.context!,
          builder: (context) => Obx(() => AlertDialog(
                title: const Text(
                  "Welcome to the App",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Text(
                          "We notice this is your first login. Please update your password",
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 17.0),
                        TextInputPassword(
                          label: "Password",
                          borderType: const UnderlineInputBorder(),
                          controller: controller.passwordCon,
                          isShowHelperText: true,
                        ),
                        const SizedBox(height: 12.0),
                      ],
                    ),
                  ),
                ),
                actions: [
                  SizedBox(
                    width: double.infinity,
                    child: ButtonLoading(
                      isLoading: controller.isLoading.value,
                      label: "Update Password",
                      function: controller.isPasswordValid.value
                          ? () {
                              controller.updatePassword();
                              Get.back();
                            }
                          : null,
                    ),
                  )
                ],
              ))));
}
