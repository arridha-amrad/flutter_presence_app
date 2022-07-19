import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Forgot Password'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Obx(() => ListView(
                children: [
                  const SizedBox(height: 12.0),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: controller.emailCon,
                    decoration: const InputDecoration(
                        helperMaxLines: 5,
                        helperText: "Please insert your registered email.",
                        labelText: "Email",
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12.0),
                  ElevatedButton(
                    onPressed: controller.isEmailValid.isTrue &&
                            controller.isLoading.isFalse
                        ? () => controller.sendResetPasswordRequest()
                        : null,
                    child: controller.isLoading.isTrue
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(),
                          )
                        : const Text("Submit"),
                  )
                ],
              )),
        ));
  }
}
