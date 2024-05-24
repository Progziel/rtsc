import 'dart:async';

import 'package:app/media/controller/universal_controller.dart';
import 'package:app/model/company_model.dart';
import 'package:app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class MyFollowingsController extends GetxController {
  MyFollowingsController(this.currentUser);
  final MyUserModel currentUser;
  // final _tabIndex = 0.obs;
  // get tabIndex => _tabIndex.value;

  StreamSubscription<DocumentSnapshot>? _companiesSubscriptions;

  final _loading = true.obs;
  String? _error;
  bool get loading => _loading.value;
  String? get error => _error;
  final _followings = <MyCompanyModel>[].obs;
  List<MyCompanyModel> get followings => _followings;

  @override
  void onInit() {
    _streamCompanies();
    super.onInit();
  }

  void _streamCompanies() {
    _loading.value = true;
    _companiesSubscriptions = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.id!)
        .snapshots()
        .listen((value) async {
      MyUserModel mediaMember =
          MyUserModel.fromMap(value.data() as Map<String, dynamic>);
      if (mediaMember.followings != null &&
          mediaMember.followings!.isNotEmpty) {
        _loadFollowings(mediaMember);
      } else {
        _followings.clear();
        _loading.value = false;
      }
    });
  }

  @override
  void onClose() {
    if (_companiesSubscriptions != null) _companiesSubscriptions!.cancel();
    super.onClose();
  }

  void _loadFollowings(MyUserModel mediaMember) async {
    _error = null;
    try {
      await FirebaseFirestore.instance
          .collection('companies')
          .where('status', isEqualTo: true)
          .where(FieldPath.documentId, whereIn: mediaMember.followings)
          .get()
          .then((value) {
        _followings.clear();
        for (DocumentSnapshot snapshot in value.docs) {
          MyCompanyModel company =
              MyCompanyModel.fromMap(snapshot.data() as Map<String, dynamic>);
          if (mediaMember.followings != null &&
              company.followers != null &&
              company.followers!.contains(mediaMember.id) &&
              mediaMember.followings!.contains(company.id)) {
            _followings.add(company);
          }
        }
      });
    } on FirebaseAuthException catch (e) {
      _error = e.code;
    } catch (e) {
      _error = 'Error: ${e.toString()}';
    }
    _loading.value = false;
  }

  Future<String?> onNotificationAction(
      MyUserModel model, String? companyId) async {
    try {
      bool isContain = model.notifications!.contains(companyId);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(model.id)
          .update({
        'notifications': isContain
            ? FieldValue.arrayRemove([companyId])
            : FieldValue.arrayUnion([companyId])
      }).then((value) async {
        isContain
            ? model.notifications!.remove(companyId)
            : model.notifications!.add(companyId!);

        isContain
            ? await FirebaseMessaging.instance.unsubscribeFromTopic(companyId!)
            : await FirebaseMessaging.instance.subscribeToTopic(companyId!);

        Get.find<MyMediaUniversalController>()
            .storage
            .write('notifications', model.notifications);
      });
      return null;
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  Future<String?> onUnfollow(MyCompanyModel company, MyUserModel user) async {
    try {
      await Future.wait([
        FirebaseFirestore.instance
            .collection('companies')
            .doc(company.id)
            .update({
          'followers': FieldValue.arrayRemove([user.id])
        }).then((value) => company.followers!.remove(user.id)),
        FirebaseFirestore.instance.collection('users').doc(user.id).update({
          'followings': FieldValue.arrayRemove([company.id]),
          'notifications': FieldValue.arrayRemove([company.id])
        }).then((value) => user.followings!.remove(company.id)),
        FirebaseMessaging.instance.unsubscribeFromTopic(company.id!)
      ]);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }
}
