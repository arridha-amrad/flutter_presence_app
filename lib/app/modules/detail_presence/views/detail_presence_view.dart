import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence_app/app/widgets/presence_card.dart';

import '../controllers/detail_presence_controller.dart';

class DetailPresenceView extends GetView<DetailPresenceController> {
  const DetailPresenceView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    final presenceIn = arguments["in"];
    final presenceOut = arguments["out"];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Presence Detail"),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10.0),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${DateFormat.EEEE().format(DateTime.parse(arguments["date"]))},",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            Text(
              "${DateFormat.yMMMMd().format(DateTime.parse(arguments["date"])).replaceAll(",", "")}.",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            const SizedBox(height: 12.0),
            Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey[200]),
                child: Column(
                  children: [
                    PresenceCard(presence: presenceIn, title: "Sign in"),
                    presenceOut == null
                        ? const SizedBox()
                        : PresenceCard(presence: presenceOut, title: "Sign out")
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
