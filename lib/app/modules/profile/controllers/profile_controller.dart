import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _employees = FirebaseFirestore.instance.collection("employees");

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUser() async* {
    final uid = _auth.currentUser!.uid;
    yield* _employees.doc(uid).snapshots();
  }

  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}
