import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence_app/app/widgets/button_loading.dart';
import 'package:presence_app/app/widgets/text_input.dart';

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
                  TextInput(
                    label: "Email",
                    controller: controller.emailCon,
                    textInputType: TextInputType.emailAddress,
                    helperText: "Please insert your registered email.",
                  ),
                  const SizedBox(height: 12.0),
                  ButtonLoading(
                    isLoading: controller.isLoading.value,
                    label: "Submit",
                    function: controller.isEmailValid.isTrue &&
                            controller.isLoading.isFalse
                        ? () => controller.sendResetPasswordRequest()
                        : null,
                  ),
                ],
              )),
        ));
  }
}
