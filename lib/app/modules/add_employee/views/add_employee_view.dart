import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: controller.emailCon,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    controller: controller.nipCon,
                    decoration: const InputDecoration(
                      labelText: "NIP",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    controller: controller.nameCon,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  ElevatedButton(
                      onPressed: controller.isEmailFilled.isTrue &&
                              controller.isNipFilled.isTrue &&
                              controller.isNameFilled.isTrue &&
                              controller.isLoading.isFalse
                          ? () => showDialog(
                                context: context,
                                builder: (context) => _alertDialog(context),
                              )
                          : null,
                      child: Text(
                        controller.isLoading.isTrue ? "Loading..." : "Add",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            )));
  }

  AlertDialog _alertDialog(BuildContext context) {
    final height = MediaQuery.of(context).size.height / 4;
    return AlertDialog(
      content: SizedBox(
        height: height < 200 ? 200 : height,
        child: Obx(() => Column(
              children: [
                TextFormField(
                  obscureText: !controller.isShowPasswordAdmin.value,
                  controller: controller.passwordConAdmin,
                  decoration: const InputDecoration(
                    hintText: "Password",
                  ),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  value: controller.isShowPasswordAdmin.value,
                  onChanged: (val) =>
                      controller.isShowPasswordAdmin.value = val!,
                  title: const Text("Show password"),
                )
              ],
            )),
      ),
      actions: [
        TextButton(
            onPressed: () {
              controller.addEmployee();
              Get.back();
            },
            child: const Text("Submit")),
        TextButton(
            onPressed: () {
              controller.passwordConAdmin.clear();
              controller.isShowPasswordAdmin.value = false;
              Get.back();
            },
            child: const Text("Cancel"))
      ],
    );
  }
}
