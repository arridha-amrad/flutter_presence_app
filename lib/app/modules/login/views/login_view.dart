import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/modules/login/controllers/login_controller.dart';
import 'package:presence_app/app/routes/app_pages.dart';
import 'package:presence_app/app/widgets/text_input_password.dart';
import 'package:presence_app/app/widgets/text_input.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Obx(() {
            return ListView(
              children: [
                const SizedBox(height: 12.0),
                TextInput(
                  textInputType: TextInputType.emailAddress,
                  label: "Email",
                  controller: controller.emailCon,
                ),
                TextInputPassword(
                  label: "Password",
                  controller: controller.passwordCon,
                ),
                ElevatedButton(
                  onPressed: controller.isEmailFilled.value &&
                          controller.isPasswordFilled.value
                      ? () => controller.login()
                      : null,
                  child: Text(
                    "Login".toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () => Get.toNamed(Routes.FORGOT_PASSWORD),
                      child: const Text("forgot password ?")),
                ),
              ],
            );
          }),
        ));
  }
}
