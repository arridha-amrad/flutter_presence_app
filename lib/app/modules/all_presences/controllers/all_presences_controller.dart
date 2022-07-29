import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/helpers/firebase_firestore/employee_controller.dart';

class AllPresencesController extends GetxController {
  DateTime? startDate;
  DateTime? endDate;

  final _employeeController = Get.put(EmployeeController());

  late Stream<QuerySnapshot<Map<String, dynamic>>> presencesStream;

  @override
  void onInit() {
    super.onInit();
    presencesStream = _employeeController.fetchAllPresenceStream();
  }

  void setDateRange(DateTimeRange dateTimeRange) {
    startDate = dateTimeRange.start;
    endDate = dateTimeRange.end;

    presencesStream = _employeeController.fetchAllPresenceStream(
        startDate: startDate, endDate: endDate);
    update();
  }
}
