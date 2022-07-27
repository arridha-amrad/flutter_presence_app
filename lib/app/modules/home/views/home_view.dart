import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:presence_app/app/modules/home/controllers/home_controller.dart';
import 'package:presence_app/app/modules/home/widgets/update_password_form.dart';
import 'package:presence_app/app/modules/presence/controllers/presence_controller.dart';
import 'package:presence_app/app/routes/app_pages.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: controller.getEmployee(),
          builder: (context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
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
            return SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(12.0),
                children: [
                  _profile(context, user),
                  const SizedBox(height: 20.0),
                  _banner(user),
                  const SizedBox(height: 12.0),
                  _latestPresence(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Last 5 days",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                          onPressed: () {}, child: const Text("Show all")),
                    ],
                  ),
                  ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 5,
                    itemBuilder: (context, index) => _briefPresenceCard(),
                  )
                ],
              ),
            );
          }),
    ));
  }

  Widget _briefPresenceCard() {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.DETAIL_PRESENCE),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        child: ListTile(
          trailing: Text(
            DateFormat.yMMMEd().format(DateTime.now()),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          title: RichText(
            text: TextSpan(
                text: "In : ",
                children: [
                  TextSpan(
                      text: DateFormat.jm().format(DateTime.now()),
                      style: const TextStyle(fontWeight: FontWeight.normal)),
                ],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )),
          ),
          subtitle: Container(
            margin: const EdgeInsets.only(top: 12.0),
            child: RichText(
              text: TextSpan(
                  text: "Out : ",
                  children: [
                    TextSpan(
                        text: DateFormat.jm().format(DateTime.now()),
                        style: const TextStyle(fontWeight: FontWeight.normal)),
                  ],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )),
            ),
          ),
        ),
      ),
    );
  }

  Widget _latestPresence() {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[300],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("In"),
              Text("-"),
            ],
          ),
          VerticalDivider(
            indent: 10,
            endIndent: 10,
            color: Colors.green,
            thickness: 5,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Out"),
              Text("-"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _banner(
    Map<String, dynamic> user,
  ) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            user["role"].toString().toUpperCase(),
            style: const TextStyle(
              decoration: TextDecoration.underline,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
          RichText(
              text: TextSpan(
                  text: "NIP : ",
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  children: [TextSpan(text: user["nip"].toString())])),
          Text(user["name"]),
        ],
      ),
    );
  }

  Widget _profile(BuildContext context, dynamic user) {
    final presenceController = Get.find<PresenceController>();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
              children: [
                Text(
                  user["name"],
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 8),
                    presenceController.currPosition == null
                        ? const Text("...")
                        : FutureBuilder(
                            future: presenceController.getAdress(),
                            builder:
                                (context, AsyncSnapshot<Placemark?> snapshot) {
                              if (snapshot.hasData) {
                                final data = snapshot.data!;
                                print("data : $data");
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${data.street},"),
                                    Text("${data.subLocality},"),
                                    Text("${data.subAdministrativeArea},"),
                                    Text("${data.country}."),
                                  ],
                                );
                              }
                              return Text("...");
                            }),
                  ],
                ),
              ],
            )),
        ClipRRect(
          borderRadius: BorderRadius.circular(150),
          child: Container(
            height: 150,
            width: 150,
            color: Colors.grey,
            child: Image.network(
              user["avatarUrl"],
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
