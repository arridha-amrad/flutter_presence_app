import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/dto/auth_response_dto.dart';

class AuthenticationController extends GetxController {
  final _auth = FirebaseAuth.instance;

  Future<void> logout() async {
    await _auth.signOut();
  }

  User? getAuthUser() => _auth.currentUser!;

  Future<AuthResponseDTO> register({
    required String email,
    required String password,
  }) async {
    AuthResponseDTO responseDTO = AuthResponseDTO();
    try {
      final res = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      responseDTO.setUserCredential = res;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        responseDTO.setMessage = "Email has been registered";
      }
      if (e.code == "weak-password") {
        responseDTO.setMessage = "Password is too weak";
      }
    } catch (e) {
      print(e);
    }
    return responseDTO;
  }

  Future<AuthResponseDTO> login({
    required String email,
    required String password,
  }) async {
    AuthResponseDTO responseDTO = AuthResponseDTO();
    try {
      final UserCredential res = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      responseDTO.setUserCredential = res;
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        responseDTO.setMessage = "Invalid email";
      }
      if (e.code == "user-not-found") {
        responseDTO.setMessage = "User not found";
      }
      if (e.code == "wrong-password") {
        responseDTO.setMessage = "Invalid email and password";
      }
    } catch (e) {
      print(e);
    }
    return responseDTO;
  }
}
