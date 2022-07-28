import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence_app/app/widgets/presence_card.dart';

import '../controllers/presence_controller.dart';

class PresenceView extends GetView<PresenceController> {
  const PresenceView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: Container(
            margin: const EdgeInsets.only(top: 20.0),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${DateFormat.EEEE().format(DateTime.now())},",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 25),
                ),
                Text(
                  "${DateFormat.yMMMMd().format(DateTime.now()).replaceAll(",", "")}.",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 25),
                ),
                const SizedBox(height: 12.0),
                Container(
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[200]),
                  child: GetBuilder<PresenceController>(builder: (controller) {
                    if (controller.presenceResult == null) {
                      return const CircularProgressIndicator();
                    }
                    final Map<String, dynamic> presenceIn =
                        controller.presenceResult!["in"];
                    Map<String, dynamic>? presenceOut =
                        controller.presenceResult!["out"];
                    return Column(
                      children: [
                        PresenceCard(presence: presenceIn, title: "Sign in"),
                        presenceOut == null
                            ? const SizedBox()
                            : PresenceCard(
                                presence: presenceOut, title: "Sign out")
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
