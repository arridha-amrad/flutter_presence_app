import 'package:get/get.dart';
import 'package:presence_app/app/modules/home/controllers/home_controller.dart';
import 'package:presence_app/app/modules/home/views/home_view.dart';
import 'package:presence_app/app/modules/presence/controllers/presence_controller.dart';
import 'package:presence_app/app/modules/presence/views/presence_view.dart';
import 'package:presence_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:presence_app/app/modules/profile/views/profile_view.dart';

class EntryController extends GetxController {
  final _homeCon = Get.put(HomeController());
  final _profileCon = Get.put(ProfileController());
  final _presenceCon = Get.put(PresenceController());

  final screens = [
    const HomeView(),
    const PresenceView(),
    const ProfileView(),
  ];

  RxInt indexPage = 0.obs;
}
