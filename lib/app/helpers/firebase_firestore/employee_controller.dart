import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence_app/app/helpers/helpers.dart';

class EmployeeController extends GetxController {
  final _employee = FirebaseFirestore.instance.collection("employees");

  final _authController = Get.put(AuthenticationController());

  Stream<DocumentSnapshot<Map<String, dynamic>>> getEmployee(
      String userId) async* {
    yield* _employee.doc(userId).snapshots();
  }

  Future<String?> updateEmployee(
      {required String userId, required Map<String, dynamic> data}) async {
    String? message;
    try {
      await _employee.doc(userId).update(data);
    } catch (e) {
      print(e);
      message = "Failed to update profile";
    }
    return message;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> findPresence(
      String userId, String dateString) async {
    return await _employee
        .doc(userId)
        .collection("presences")
        .doc(dateString)
        .get();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> fetchStreamPresence() async* {
    final auth = _authController.getAuthUser();
    final dateString =
        DateFormat.yMd().format(DateTime.now()).replaceAll("/", "-");
    yield* _employee
        .doc(auth!.uid)
        .collection("presences")
        .doc(dateString)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>
      fetcheStreamPresenceLastFive() async* {
    final auth = _authController.getAuthUser();
    final dateString =
        DateFormat.yMd().format(DateTime.now()).replaceAll("/", "-");

    yield* _employee
        .doc(auth!.uid)
        .collection("presences")
        .orderBy("date", descending: true)
        .limit(5)
        .snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> createPresence(
      String userId, Map<String, dynamic> data, String dateString) async {
    final doc = _employee.doc(userId).collection("presences").doc(dateString);
    await doc.set(data);
    return doc.get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> updatePresence(
      String userId, Map<String, dynamic> data, String dateString) async {
    final doc = _employee.doc(userId).collection("presences").doc(dateString);
    await doc.update(data);
    return doc.get();
  }

  Future<void> saveEmployee({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _employee.doc(userId).set(data);
    } catch (e) {
      print(e);
    }
  }
}
