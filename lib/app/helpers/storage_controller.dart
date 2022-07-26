import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:presence_app/app/helpers/helpers.dart';

enum StorageFolder { avatar }

class StorageController extends GetxController {
  final _storageRef = FirebaseStorage.instance.ref();

  Future<String> store(
      {required XFile xFile, required StorageFolder location}) async {
    final strRandom = Helpers.stringGenerator(length: 55);
    final file = File(xFile.path);
    final fileName = "$strRandom.${xFile.name.split(".").last}";
    String folder = "";
    switch (location) {
      case StorageFolder.avatar:
        folder = "avatar";
        break;
      default:
        folder = "";
    }
    await _storageRef.child("$folder/$fileName").putFile(file);
    return _storageRef.child("$folder/$fileName").getDownloadURL();
  }

  Future<void> delete(
      {required String url, required StorageFolder location}) async {
    final a = url.split("avatar").last;
    final b = a.split("?").first;
    final fileName = b.split("%2F").last;
    String folder = "";
    switch (location) {
      case StorageFolder.avatar:
        folder = "avatar";
        break;
      default:
        folder = "";
    }
    if (fileName != "profil-pic_dummy.png") {
      await _storageRef.child("$folder/$fileName").delete();
    }
  }
}
