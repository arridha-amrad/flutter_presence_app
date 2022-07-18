import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence_app/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

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
          child: Form(
              key: controller.formKey,
              child: Obx(() {
                return ListView(
                  children: [
                    const SizedBox(height: 12.0),
                    TextFormField(
                      controller: controller.emailCon,
                      validator: (val) => controller.validateEmail(val),
                      decoration: const InputDecoration(
                          labelText: "Email", border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12.0),
                    TextFormField(
                      controller: controller.passwordCon,
                      validator: (val) => controller.validatePassword(val),
                      obscureText: !controller.isShowPassword.value,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: controller.isShowPassword.value,
                      onChanged: (val) {
                        if (val != null) {
                          controller.isShowPassword.value = val;
                        }
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text("Show Password"),
                    ),
                    const SizedBox(height: 12.0),
                    ElevatedButton(
                        onPressed: controller.isEmailFilled.value &&
                                controller.isPasswordFilled.value
                            ? () {
                                if (controller.formKey.currentState!
                                    .validate()) {
                                  controller.login();
                                }
                              }
                            : null,
                        child: Text(
                          "Login".toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        )),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () => {},
                          child: const Text("forgot password ?")),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account ?"),
                        TextButton(
                            onPressed: () => Get.offNamed(Routes.ADD_EMPLOYEE),
                            child: const Text("register")),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                  ],
                );
              })),
        ));
  }
}