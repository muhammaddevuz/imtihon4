import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:imtihon4/controllers/user_controller.dart';

class FirebaseAuthServices {
  UserController userController = UserController();

  Future<void> signIn(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUp(String email, String pasword, String name,
      String? curLocateName, double? lat, double? lng, File? imageUrl) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pasword);
      userController.addUser(FirebaseAuth.instance.currentUser!.uid, name,
          email, curLocateName, lat, lng, imageUrl);
    } catch (e) {
      return;
    }
  }

  Future<void> resetPasword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: email,
    );
  }
}
