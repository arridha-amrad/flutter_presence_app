import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/helpers/firebase_firestore/employee_controller.dart';
import 'package:presence_app/app/modules/home/controllers/home_controller.dart';
import 'package:presence_app/app/modules/home/widgets/update_password_form.dart';
import 'package:presence_app/app/routes/app_pages.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('HomeView'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () => Get.toNamed(Routes.PROFILE),
                icon: const Icon(Icons.person))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          child: const Icon(Icons.logout),
          onPressed: () => controller.logout(),
        ),
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: controller.getEmployee(),
            builder: (context,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final data = snapshot.data;
              if (data == null) {
                return const Center(
                  child: Text("No user for this session"),
                );
              }
              final user = data.data()!;
              if (user["isFirstLogin"]) {
                showUpdatePasswordDialog(controller);
              }
              return ListView(
                children: [
                  Text(user["email"]),
                ],
              );
            }));
  }
}
