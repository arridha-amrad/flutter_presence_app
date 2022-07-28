import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence_app/app/helpers/util.dart';
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
          if (i == 1) {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => Helpers.showDialog(
                  function: () {
                    controller.indexPage.value = i;
                    final presenceCon = Get.find<PresenceController>();
                    presenceCon.signPresence();
                  },
                  cancelFunction: () {},
                  context: context,
                  title: "Signing confirmation",
                  message: "Are you sure to continue signing your presence ?"),
            );
          } else {
            controller.indexPage.value = i;
          }
        },
      ),
    );
  }
}
