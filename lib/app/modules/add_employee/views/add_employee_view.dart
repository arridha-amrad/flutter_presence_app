import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/widgets/text_input.dart';
import 'package:presence_app/app/widgets/text_input_password.dart';
import '../controllers/add_employee_controller.dart';

class AddEmployeeView extends GetView<AddEmployeeController> {
  const AddEmployeeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add New Employee'),
          centerTitle: true,
        ),
        body: Obx(() => Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView(
                children: [
                  const SizedBox(height: 12.0),
                  TextInput(
                    textInputType: TextInputType.emailAddress,
                    label: "Email",
                    controller: controller.emailCon,
                  ),
                  TextInput(label: "NIP", controller: controller.nipCon),
                  TextInput(label: "Name", controller: controller.nameCon),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Role",
                    ),
                    items: controller.roles.map(_buildRoleOption).toList(),
                    onChanged: (val) => controller.role.value = val!,
                  ),
                  ElevatedButton(
                      onPressed: controller.isEmailValid.isTrue &&
                              controller.isNipFilled.isTrue &&
                              controller.isNameFilled.isTrue &&
                              controller.isLoading.isFalse
                          ? () => showDialog(
                                context: context,
                                builder: (context) => _alertDialog(context),
                              )
                          : null,
                      child: const Text(
                        "Add",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            )));
  }

  DropdownMenuItem<String> _buildRoleOption(String role) => DropdownMenuItem(
        value: role,
        child: Text(role),
      );

  AlertDialog _alertDialog(BuildContext context) {
    final height = MediaQuery.of(context).size.height / 4;
    return AlertDialog(
      title: const Text(
        "Verification Admin",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Obx(() => SizedBox(
            height: height < 200 ? 200 : height,
            child: Column(
              children: [
                TextInputPassword(
                  errorText: controller.errorText.value,
                  label: "Password",
                  borderType: const UnderlineInputBorder(),
                  controller: controller.passwordConAdmin,
                ),
              ],
            ),
          )),
      actions: [
        TextButton(
            onPressed: () {
              controller.passwordConAdmin.clear();
              controller.errorText.value = "";
              Get.back();
            },
            child: const Text("Cancel")),
        Obx(() => TextButton(
            onPressed: controller.isLoading.isFalse &&
                    controller.isPasswordFilled.isTrue
                ? () => controller.addEmployee()
                : null,
            child: controller.isLoading.isTrue
                ? const SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(),
                  )
                : const Text("Submit"))),
      ],
    );
  }
}
