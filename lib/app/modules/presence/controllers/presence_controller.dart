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
  Position? userCurrentPosition;

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

  Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return {"error": "Location services are currently disabled"};
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
            "Your device disabled this app from accessing your location. Please enable the permission to continue."
      };
    }
    Position position = await Geolocator.getCurrentPosition();
    userCurrentPosition = position;
    return {
      "error": null,
    };
  }

  Future<bool> signPresence() async {
    _findingLocationDialog();
    final result = await determinePosition();
    if (result["error"] != null) {
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) => Helpers.showDialog(
              context: context,
              title: "Location Disabled",
              message: result["error"]));
      return false;
    }
    final Position position = userCurrentPosition!;
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
      "date": DateTime.now().toIso8601String(),
      "latitude": position.latitude,
      "longitude": position.longitude,
      "status": status,
    };
    bool isUpdate = false;
    if (presence == null) {
      final data = await _employeeController.createPresence(
        uid,
        {
          "date": dateString,
          "in": presenceData,
        },
        dateString,
      );
      presenceResult = data.data()!;
      isUpdate = true;
      Helpers.setToast(message: "sign in accepted");
      Get.back();
    } else if (presence["in"] != null && presence["out"] == null) {
      final data = await _employeeController.updatePresence(
        uid,
        {"date": dateString, "out": presenceData},
        dateString,
      );
      Helpers.setToast(message: "sign out  accepted");
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
    update();
    return true;
  }

  _findingLocationDialog() {
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
  }
}
