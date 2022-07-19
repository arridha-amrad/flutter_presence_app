import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/modules/home/controllers/home_controller.dart';

showUpdatePassword(HomeController controller) {
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
                        TextFormField(
                          controller: controller.passwordCon,
                          obscureText: !controller.isShowPassword.value,
                          decoration: const InputDecoration(
                              helperText:
                                  "Minimum six characters, at least one letter, one number and one special character.",
                              helperMaxLines: 3,
                              hintText: "Password",
                              border: UnderlineInputBorder()),
                        ),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          value: controller.isShowPassword.value,
                          dense: true,
                          onChanged: (val) {
                            if (val != null) {
                              controller.isShowPassword.value = val;
                            }
                          },
                          title: const Text("Show Password"),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        const SizedBox(height: 12.0),
                      ],
                    ),
                  ),
                ),
                actions: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: controller.isPasswordValid.value
                            ? () {
                                controller.updatePassword();
                                Get.back();
                              }
                            : null,
                        child: const Text("Update Password")),
                  )
                ],
              ))));
}
