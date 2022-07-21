import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence_app/app/routes/app_pages.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: true,
        ),
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: controller.getUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData) {
                return const Center(
                  child: Text("User not found"),
                );
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Something went wrong"),
                );
              }
              final user = snapshot.data!.data()!;
              return ListView(
                padding: const EdgeInsets.all(12.0),
                children: [
                  const CircleAvatar(radius: 50),
                  const SizedBox(height: 12.0),
                  Text(
                    user["name"].toUpperCase(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    user["email"],
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20.0),
                  _textButton(
                      label: "Update Profile",
                      icon: Icons.person,
                      function: () => Get.toNamed(
                            Routes.UPDATE_PROFILE,
                            arguments: user,
                          )),
                  _textButton(
                      label: "Update Password",
                      icon: Icons.vpn_key,
                      function: () => Get.toNamed(Routes.UPDATE_PASSWORD)),
                  user["role"] == "admin"
                      ? (_textButton(
                          label: "Add Employee",
                          icon: Icons.person_add,
                          function: () => Get.toNamed(Routes.ADD_EMPLOYEE)))
                      : const SizedBox(),
                  _textButton(
                    label: "Logout",
                    icon: Icons.logout,
                    function: () => controller.logout(),
                  ),
                ],
              );
            }));
  }

  TextButton _textButton({
    required String label,
    required IconData icon,
    required VoidCallback function,
  }) {
    return TextButton.icon(
        onPressed: function,
        icon: Icon(icon, color: Colors.grey),
        label: Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ));
  }
}
