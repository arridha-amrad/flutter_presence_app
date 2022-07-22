import 'package:get/get.dart';
import 'package:presence_app/app/helpers/firebase_firestore/employee_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<EmployeeController>(
      () => EmployeeController(),
    );
  }
}
