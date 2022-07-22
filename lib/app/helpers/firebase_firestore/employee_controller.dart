import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class EmployeeController extends GetxController {
  final _employee = FirebaseFirestore.instance.collection("employees");

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
