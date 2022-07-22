import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/helpers/helpers.dart';

import 'package:presence_app/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  final _authController = Get.put(AuthenticationController());
  final _employeeController = Get.put(EmployeeController());

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUser() async* {
    yield* _employeeController.getEmployee(_authController.getAuthUser()!.uid);
  }

  Future<void> logout() async {
    await _authController.logout();
    Get.offAllNamed(Routes.LOGIN);
  }
}
