import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:presence_app/app/helpers/helpers.dart';
import 'package:geocoding/geocoding.dart';

class PresenceController extends GetxController {
  final _employeeController = Get.put(EmployeeController());
  final _authController = Get.put(AuthenticationController());

  Position? currPosition;

  Future<Placemark?> getAdress() async {
    Placemark? place;
    if (currPosition == null) return place;
    List<Placemark> placemarks = await placemarkFromCoordinates(
        currPosition!.latitude, currPosition!.longitude);
    place = placemarks[0];
    return place;
  }

  Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return {"error": "Location services are disabled"};
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return {"error": "Location permissions are denied"};
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        "error":
            "Location permissions are permanently denied, we cannot request permissions."
      };
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    currPosition = position;
    await _employeeController
        .updateEmployee(userId: _authController.getAuthUser()!.uid, data: {
      "position": {
        "latitude": position.latitude,
        "longitude": position.longitude,
      }
    });
    return {
      "position": position,
      "error": null,
    };
  }
}
