import 'package:firebase_auth/firebase_auth.dart';

class AuthResponseDTO {
  UserCredential? _userCredential;
  String? _message;

  AuthResponseDTO();

  set setMessage(String message) => _message = message;
  set setUserCredential(UserCredential userCredential) =>
      _userCredential = userCredential;

  UserCredential? get getUserCredential => _userCredential;
  String? get message => _message;
}
