import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeFireStore {
  static final _employee = FirebaseFirestore.instance.collection("employees");

  static Future<String?> update(
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

  static Future<void> save({
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
