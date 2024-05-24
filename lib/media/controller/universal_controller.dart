import 'dart:typed_data';

import 'package:app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MyMediaUniversalController extends GetxController {
  MyMediaUniversalController(this.currentUser);
  final MyUserModel currentUser;

  final _profileUpdated = false.obs, _tabIndex = 0.obs, _userTabIndex = 0.obs;
  final GetStorage storage = GetStorage('RTSC');
  set setUserTabIndex(int i) => _userTabIndex.value = i;
  get tabIndex => _tabIndex.value;
  get userTabIndex => _userTabIndex.value;
  set setTabIndex(int v) => _tabIndex.value = v;

  bool get profileUpdated => _profileUpdated.value;

  @override
  void onInit() {
    _checkSubscription();
    super.onInit();
  }

  Future<void> _checkSubscription() async {
    if (storage.read('notifications') == null) {
      for (String id in currentUser.notifications ?? []) {
        await FirebaseMessaging.instance.subscribeToTopic(id);
      }
      storage.write('notifications', currentUser.notifications ?? []);
    }
  }

  ///Profile
  Future<String?> updateProfile(Uint8List? bytes, String fullName, String phone,
      String mediaOutletName) async {
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
        'mediaOutletName': mediaOutletName,
      }).then((value) {
        if (profilePicUrl != null) currentUser.profilePicUrl = profilePicUrl;
        currentUser.fullName = fullName;
        currentUser.phone = phone;
        currentUser.mediaOutletName = mediaOutletName;
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
