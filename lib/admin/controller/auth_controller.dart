import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyAdminAuthController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  Future<String?> loginUser() async {
    try {
      print('${email.text.trim()}@gmail.com');
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: '${email.text.trim()}@gmail.com',
          password: password.text.trim());
      return null;
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }
}
