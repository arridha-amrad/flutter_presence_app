import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence_app/app/helpers/firebase_firestore/employee_controller.dart';

import 'package:presence_app/app/modules/home/controllers/home_controller.dart';
import 'package:presence_app/app/modules/home/widgets/update_password_form.dart';
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
                        "Latest presences",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                          onPressed: () => Get.toNamed(Routes.ALL_PRESENCES),
                          child: const Text("Show all")),
                    ],
                  ),
                  _latestPresences(),
                ],
              ),
            );
          }),
    ));
  }

  Widget _latestPresences() {
    final employeeController = Get.find<EmployeeController>();
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: employeeController.fetcheStreamPresenceLastFive(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(
              child: Text("You have no presence history"),
            );
          }
          return ListView.builder(
              itemCount: docs.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final result = docs[index].data();
                return GestureDetector(
                  onTap: () =>
                      Get.toNamed(Routes.DETAIL_PRESENCE, arguments: result),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    child: ListTile(
                      trailing: Text(
                        DateFormat.yMMMEd()
                            .format(DateTime.parse(result["date"])),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      title: RichText(
                        text: TextSpan(
                            text: "In : ",
                            children: [
                              TextSpan(
                                  text: DateFormat.jm().format(
                                      DateTime.parse(result["in"]["date"])),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal)),
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
                                    text: result["out"] != null
                                        ? DateFormat.jm().format(DateTime.parse(
                                            result["out"]["date"]))
                                        : "-",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal)),
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
              });
        });
  }

  Widget _latestPresence() {
    final employeeController = Get.put(EmployeeController());
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: employeeController.fetchStreamPresence(),
        builder: (context, snapshot) {
          String? signInHour;
          String? signOutHour;
          if (snapshot.hasData) {
            final result = snapshot.data!.data();
            if (result != null) {
              signInHour =
                  DateFormat.Hms().format(DateTime.parse(result["in"]["date"]));
              if (result["out"] != null) {
                signOutHour = DateFormat.Hms()
                    .format(DateTime.parse(result["out"]["date"]));
              }
            }
          }
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
                    const Icon(Icons.login),
                    const SizedBox(height: 8),
                    snapshot.connectionState == ConnectionState.waiting
                        ? const SizedBox(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator(),
                          )
                        : Text(signInHour ?? "-")
                  ],
                ),
                const VerticalDivider(
                  indent: 10,
                  endIndent: 10,
                  color: Colors.green,
                  thickness: 5,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout),
                    const SizedBox(height: 8),
                    snapshot.connectionState == ConnectionState.waiting
                        ? const SizedBox(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator(),
                          )
                        : Text(signOutHour ?? "-")
                  ],
                ),
              ],
            ),
          );
        });
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 35,
                        child: Text(user["address"]))
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
