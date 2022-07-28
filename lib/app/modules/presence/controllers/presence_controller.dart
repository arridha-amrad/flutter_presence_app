import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:presence_app/app/helpers/helpers.dart';
import 'package:geocoding/geocoding.dart';

class PresenceController extends GetxController {
  final _employeeController = Get.put(EmployeeController());
  final _authController = Get.put(AuthenticationController());

  final officeLocation = {
    "latitude": 0.5101267,
    "longitude": 101.4499433,
  };

  Map<String, dynamic>? presenceResult;
  RxBool isLoading = false.obs;

  double _calculateDistance(Position currentPosition) {
    return Geolocator.distanceBetween(
      officeLocation["latitude"]!,
      officeLocation["longitude"]!,
      currentPosition.latitude,
      currentPosition.longitude,
    );
  }

  Future<Placemark> _getAddress(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    return placemarks[0];
  }

  Future<Map<String, dynamic>> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return {"error": "Location services are disabled"};
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return {"error": "Location permissions are denied"};
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return {
        "error":
            "Location permissions are permanently denied, we cannot request permissions."
      };
    }
    Position position = await Geolocator.getCurrentPosition();
    return {
      "position": position,
      "error": null,
    };
  }

  Future<void> signPresence() async {
    showDialog(
      barrierDismissible: false,
      context: Get.context!,
      builder: (context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(15.0),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: const [
                SizedBox(
                  height: 17,
                  width: 17,
                  child: CircularProgressIndicator(),
                ),
                SizedBox(
                  width: 12.0,
                ),
                Text("Finding your location...")
              ],
            ),
          ),
        ),
      ),
    );
    final resultPosition = await _determinePosition();
    if (resultPosition["error"] != null) {
      Helpers.setToast(message: "failed signing the presence");
      return;
    }
    final Position position = resultPosition["position"];

    String status = "inside area";
    // if user position more than  200m from office, set status 'outside area'
    final double distance = _calculateDistance(position);
    if (distance > 200) {
      status = "outside area";
    }
    final placemark = await _getAddress(position);
    final address =
        "${placemark.street}, ${placemark.subLocality}, ${placemark.subAdministrativeArea}";
    final uid = _authController.getAuthUser()!.uid;
    final dateNow = DateTime.now();
    final dateString = DateFormat.yMd().format(dateNow).replaceAll("/", "-");
    final fetchedPresence =
        await _employeeController.findPresence(uid, dateString);
    final presence = fetchedPresence.data();
    final presenceData = {
      "address": address,
      "date": dateNow.toIso8601String(),
      "latitude": position.latitude,
      "longitude": position.longitude,
      "status": status,
    };
    bool isUpdate = false;
    if (presence == null) {
      final data = await _employeeController.createPresence(
        uid,
        {
          "date": DateTime.now().toIso8601String(),
          "in": presenceData,
        },
        dateString,
      );
      presenceResult = data.data()!;
      isUpdate = true;
      Get.back();
    } else if (presence["in"] != null && presence["out"] == null) {
      final data = await _employeeController.updatePresence(
        uid,
        {"date": dateNow.toIso8601String(), "out": presenceData},
        dateString,
      );
      Helpers.setToast(message: "sign out presence accepted");
      presenceResult = data.data()!;
      isUpdate = true;
      Get.back();
    } else if (presence["in"] != null && presence["out"] != null) {
      Get.back();
      isUpdate = false;
      presenceResult = presence;
      showDialog(
          context: Get.context!,
          builder: (context) => Helpers.showDialog(
                context: Get.context!,
                title: "Forbidden",
                message: "You have sign your presence twice",
              ));
    }
    if (isUpdate) {
      await _employeeController.updateEmployee(userId: uid, data: {
        "address": address,
        "position": {
          "longitude": position.longitude,
          "latitude": position.latitude,
        }
      });
    }
    Helpers.setToast(message: "sign out presence accepted");
    update();
  }
}
