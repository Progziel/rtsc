import 'dart:typed_data';

import 'package:app/company/view/dashboard/screen.dart';
import 'package:app/model/company_model.dart';
import 'package:app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class MyCompanyAuthController extends GetxController {
  final _formType = 1.obs; // 0 for signUp, 1 for login, 2 for forget
  int get auth => _formType.value;
  set setAuth(int v) => _formType.value = v;

  final loginFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final signUpFormKey = GlobalKey<FormState>();
  final companyName = TextEditingController();
  final ownerName = TextEditingController();
  final description = TextEditingController();
  // final mailingAddress = TextEditingController();
  // final phone = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final logoImage = Rx<Uint8List?>(null);

  Future<String?> createCompany(
      MyCompanyModel model, String password, Uint8List? logoBytes) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: model.email!, password: password)
          .then((value) async {
        String? profilePicUrl;
        if (logoBytes != null && logoBytes.isNotEmpty) {
          await _uploadLogo(logoBytes).then((value) =>
              profilePicUrl = value.startsWith('https://') ? value : null);
        }
        DocumentReference user =
            FirebaseFirestore.instance.collection('users').doc(value.user!.uid);
        await user
            .set(MyUserModel(
          id: value.user!.uid,
          email: model.email,
          password: password,
          fullName: model.ownerName,
          // phone: model.phone,
          companyId: value.user!.uid,
          userType: MyUserType.admin,
          status: true,
          profilePicUrl: profilePicUrl,
        ).toMap())
            .then((value1) async {
          DocumentReference company = FirebaseFirestore.instance
              .collection('companies')
              .doc(value.user!.uid);
          model.id = value.user!.uid;
          model.logoUrl = profilePicUrl;
          model.followers = [];
          await company.set(model.toMap());
        });
      });
      return null;
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  Future<String> _uploadLogo(Uint8List data) async {
    try {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('logos')
          .child(const Uuid().v4());
      await ref.putData(data, SettableMetadata(contentType: 'image/png'));
      String url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      return e.code;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  Future<String?> loginUser(MyUserModel model) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: model.email!, password: model.password!);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  ///If User Logged In
  final _currentUserExits = false.obs, _loading = false.obs;
  String? _error;
  MyUserModel? _currentUser;
  MyCompanyModel? _currentCompany;
  bool get currentUserExits => _currentUserExits.value;
  bool get loading => _loading.value;
  String? get error => _error;
  MyUserModel? get currentUser => _currentUser;
  MyCompanyModel? get currentCompany => _currentCompany;

  void loadInitialData() async {
    _currentUserExits.value = (FirebaseAuth.instance.currentUser != null);
    if (_currentUserExits.value) {
      _loading.value = true;
      _error = null;
      _currentUser = null;
      _currentCompany = null;

      try {
        if (FirebaseAuth.instance.currentUser!.email != 'admin@gmail.com') {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get()
              .then((value) async {
            _currentUser = MyUserModel.fromMap(value.data()!);
            if (_currentUser!.userType != MyUserType.mediaMember) {
              if (FirebaseAuth.instance.currentUser!.emailVerified) {
                if (_currentUser!.status!) {
                  await FirebaseFirestore.instance
                      .collection('companies')
                      .doc(_currentUser!.companyId)
                      .get()
                      .then((value) {
                    _currentCompany = MyCompanyModel.fromMap(value.data()!);
                    if (_currentCompany!.register != null &&
                        _currentCompany!.register == true &&
                        _currentCompany!.status != null &&
                        _currentCompany!.status == true &&
                        _currentUser!.status != null &&
                        _currentUser!.status == true) {
                      Get.offAll(() => MyCompanyDashboardScreen(
                          currentCompany: _currentCompany!,
                          currentUser: _currentUser!));
                    } else {
                      _loading.value = false;
                    }
                  });
                } else {
                  _loading.value = false;
                }
              } else {
                await FirebaseAuth.instance.currentUser!
                    .sendEmailVerification();
                await FirebaseAuth.instance.signOut();
                _error = 'A verification email has been sent to your email, '
                    'please click on the link to verify your email address.';
                _loading.value = false;
              }
            } else {
              _error = 'Invalid User, please enter valid '
                  'Company/Management Member/PR Member credentials';
              _loading.value = false;
            }
          });
        } else {
          _error = 'Invalid User, please enter valid '
              'Company/Management Member/PR Member credentials';
          _loading.value = false;
        }
      } on FirebaseAuthException catch (e) {
        _error = e.code;
        _loading.value = false;
      } catch (e) {
        _error = 'Error1: ${e.toString()}';
        _loading.value = false;
      }
    }
  }

  void onLogout() async {
    companyName.clear();
    ownerName.clear();
    email.clear();
    password.clear();
    description.clear();
    confirmPassword.clear();
    await FirebaseAuth.instance.signOut();
    _error = null;
    _currentUser = null;
    _currentCompany = null;
    _loading.value = false;
    _currentUserExits.value = (FirebaseAuth.instance.currentUser != null);
  }

  Future<String> passwordRecovery() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      return 'Recovery email has been sent to your email.';
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }
}
