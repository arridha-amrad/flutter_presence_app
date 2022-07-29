import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence_app/app/helpers/helpers.dart';

import '../controllers/all_presences_controller.dart';

class AllPresencesView extends GetView<AllPresencesController> {
  const AllPresencesView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final employeeController = Get.put(EmployeeController());
    return Scaffold(
        appBar: AppBar(
          title: const Text('All Presences'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () => showDateRangePicker(
                            context: context,
                            firstDate: DateTime(2022),
                            lastDate: DateTime(2100))
                        .then((value) {
                      if (value != null) {
                        controller.setDateRange(value);
                      }
                    }),
                icon: const Icon(Icons.filter_list))
          ],
        ),
        body: GetBuilder<AllPresencesController>(builder: (controller) {
          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: controller.presencesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text("Fetching error"),
                  );
                }
                final data = snapshot.data!.docs;
                if (data.isEmpty) {
                  return const Center(
                    child: Text("No presence history found."),
                  );
                }
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final presence = data[index].data();
                    return Container(
                      margin: const EdgeInsets.all(12.0),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey[200]),
                      child: Column(
                        children: [
                          Text(
                            presence["date"],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic),
                          ),
                          _presenceCard(presence["in"], "Sign in"),
                          const SizedBox(height: 10),
                          presence["out"] == null
                              ? const SizedBox()
                              : _presenceCard(presence["out"], "Sign out")
                        ],
                      ),
                    );
                  },
                );
              });
        }));
  }

  _presenceCard(Map<String, dynamic> presence, String title) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        children: [
          const SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_pin,
                color: Colors.red,
              ),
              const SizedBox(width: 12.0),
              Expanded(child: Text(presence["address"]))
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.radar,
                color: Colors.red,
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(presence["status"]))
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.satellite_alt,
                color: Colors.red,
              ),
              const SizedBox(width: 12),
              Expanded(
                  child:
                      Text("${presence["latitude"]}, ${presence["longitude"]}"))
            ],
          ),
        ],
      ),
    );
  }
}
