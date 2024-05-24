import 'dart:typed_data';

import 'package:app/model/company_model.dart';
import 'package:app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidebarx/sidebarx.dart';

class MyCompanyUniversalController extends GetxController {
  MyCompanyUniversalController(this.currentCompany, this.currentUser);
  final MyCompanyModel currentCompany;
  final MyUserModel currentUser;

  final _profileUpdated = false.obs,
      _tabIndex = 0.obs,
      _userTabIndex = 0.obs,
      _actionButtonText = ''.obs;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late SidebarXController sideBarController;
  bool get profileUpdated => _profileUpdated.value;
  get tabIndex => _tabIndex.value;
  get userTabIndex => _userTabIndex.value;
  get actionButtonText => _actionButtonText.value;

  void setSideBarController() => sideBarController =
      SidebarXController(selectedIndex: tabIndex, extended: true);
  set setTabIndex(int v) {
    _tabIndex.value = v;
    if (currentUser.userType != MyUserType.prMember) {
      _actionButtonText.value = v == 1
          ? 'Create User'
          : v == 3
              ? 'Create Post'
              : '';
    } else {
      _actionButtonText.value = v == 0 ? 'Create Post' : '';
    }
  }

  set setUserTabIndex(int i) => _userTabIndex.value = i;
  set setActionButtonText(String s) => _actionButtonText.value = s;

  ///Profile
  Future<String?> updateProfile(
      Uint8List? bytes, String fullName, String phone) async {
    try {
      String? profilePicUrl;
      if (bytes != null) {
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('logos')
            .child(currentUser.id!);
        await ref.putData(bytes, SettableMetadata(contentType: 'image/png'));
        String url = await ref.getDownloadURL();
        profilePicUrl = url.startsWith('https://') ? url : null;
      }
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.id)
          .update({
        if (profilePicUrl != null) 'profilePicUrl': profilePicUrl,
        'fullName': fullName,
        'phone': phone,
      }).then((value) {
        if (profilePicUrl != null) {
          if (currentUser.userType == MyUserType.admin) {
            FirebaseFirestore.instance
                .collection('companies')
                .doc(currentUser.companyId)
                .update({'logoUrl': profilePicUrl});
          }
          currentUser.profilePicUrl = profilePicUrl;
        }
        currentUser.fullName = fullName;
        currentUser.phone = phone;
        _profileUpdated.value = !_profileUpdated.value;
      });
      return null;
    } on FirebaseException catch (e) {
      return e.code;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  ///Profile
  Future<String?> changePassword(
      String currentPassword, String newPassword) async {
    try {
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(EmailAuthProvider.credential(
              email: FirebaseAuth.instance.currentUser!.email!,
              password: currentPassword))
          .then((value) async => await value.user!.updatePassword(newPassword))
          .then((value) async => await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.id)
              .update({'password': newPassword}))
          .then((value) => currentUser.password = newPassword);
      return null;
    } on FirebaseException catch (e) {
      return e.code;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }
}
