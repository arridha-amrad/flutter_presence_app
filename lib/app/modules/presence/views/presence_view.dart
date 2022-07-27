import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/presence_controller.dart';

class PresenceView extends GetView<PresenceController> {
  const PresenceView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('PresenceView'),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: controller.determinePosition(),
          builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final result = snapshot.data!;
            return result["error"] == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("latitude : "),
                          Text(result["position"].latitude.toString()),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("longitude : "),
                          Text(result["position"].longitude.toString()),
                        ],
                      ),
                    ],
                  )
                : Center(
                    child: Text(result["error"]),
                  );
          },
        ));
  }
}
