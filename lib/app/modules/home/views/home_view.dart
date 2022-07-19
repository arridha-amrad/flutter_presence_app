import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/modules/home/controllers/home_controller.dart';
import 'package:presence_app/app/modules/home/widgets/update_password_form.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('HomeView'),
          centerTitle: true,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.person_add))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          child: const Icon(Icons.logout),
          onPressed: () => controller.logout(),
        ),
        body: FutureBuilder(
            future: controller.getUser(),
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
                showUpdatePassword(controller);
              }
              return ListView(
                children: [
                  Text(user["email"]),
                ],
              );
            }));
  }
}
