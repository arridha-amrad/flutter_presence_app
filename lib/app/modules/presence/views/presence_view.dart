import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/presence_controller.dart';

class PresenceView extends GetView<PresenceController> {
  const PresenceView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                        _presenceCard(presenceIn, "Sign in"),
                        presenceOut == null
                            ? const SizedBox()
                            : _presenceCard(presenceOut, "Sign out")
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

  _presenceCard(
    Map<String, dynamic> presence,
    String title,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.all(12),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_pin,
                color: Colors.red,
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(presence["address"]))
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.access_time,
                color: Colors.red,
              ),
              const SizedBox(width: 12),
              Expanded(
                  child: Text(DateFormat.Hms()
                      .format(DateTime.parse(presence["date"]))))
            ],
          )
        ],
      ),
    );
  }
}
