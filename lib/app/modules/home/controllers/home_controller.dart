import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/routes/app_pages.dart';

class HomeController extends GetxController {
  final _auth = FirebaseAuth.instance;
  Future<void> logout() async {
    await _auth.signOut();
    Get.offNamed(Routes.LOGIN);
  }
}
