import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence_app/app/routes/app_pages.dart';

import '../controllers/add_employee_controller.dart';

class AddEmployeeView extends GetView<AddEmployeeController> {
  const AddEmployeeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Register Employee'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
              key: controller.formKey,
              child: ListView(
                children: [
                  const SizedBox(height: 12.0),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: controller.emailCon,
                    validator: (val) => controller.validateEmail(val),
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    controller: controller.nipCon,
                    validator: (val) => controller.validateNip(val),
                    decoration: const InputDecoration(
                      labelText: "NIP",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    controller: controller.nameCon,
                    validator: (val) => controller.validateName(val),
                    decoration: const InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Obx(() => ElevatedButton(
                      onPressed: controller.isEmailFilled.value &&
                              controller.isNipFilled.value &&
                              controller.isNameFilled.value
                          ? () {
                              if (controller.formKey.currentState!.validate()) {
                                controller.register();
                              }
                            }
                          : null,
                      child: const Text("Register"))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Have an account ?"),
                      TextButton(
                          onPressed: () => Get.offNamed(Routes.LOGIN),
                          child: const Text("login"))
                    ],
                  ),
                  const SizedBox(height: 12.0),
                ],
              )),
        ));
  }
}
