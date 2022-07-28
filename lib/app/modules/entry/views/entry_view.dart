import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence_app/app/modules/presence/controllers/presence_controller.dart';

import '../controllers/entry_controller.dart';

class EntryView extends GetView<EntryController> {
  const EntryView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.indexPage.value,
            children: controller.screens,
          )),
      bottomNavigationBar: ConvexAppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        style: TabStyle.fixedCircle,
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.fingerprint, title: 'Add'),
          TabItem(icon: Icons.message, title: 'Profile'),
        ],
        initialActiveIndex: 0, //optional, default as 0
        onTap: (int i) async {
          controller.indexPage.value = i;
          if (i == 1) {
            final presenceCon = Get.find<PresenceController>();
            await presenceCon.signPresence();
          }
        },
      ),
    );
  }
}
