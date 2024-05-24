import 'dart:async';

import 'package:app/company/view/dashboard/screen.dart';
import 'package:app/model/company_model.dart';
import 'package:app/model/interactions_model.dart';
import 'package:app/model/post_model.dart';
import 'package:app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class MyAnalyticsController extends GetxController {
  StreamSubscription<QuerySnapshot>? _postsSubscription,
      _companiesSubscriptions,
      _usersSubscriptions,
      _interactionsSubscriptions;

  @override
  void onInit() {
    _streamPosts();
    _streamCompanies();
    _streamUsers();
    _streamInteractions();
    super.onInit();
  }

  @override
  void onClose() {
    if (_postsSubscription != null) _postsSubscription!.cancel();
    if (_companiesSubscriptions != null) _companiesSubscriptions!.cancel();
    if (_usersSubscriptions != null) _usersSubscriptions!.cancel();
    if (_interactionsSubscriptions != null) {
      _interactionsSubscriptions!.cancel();
    }
    super.onClose();
  }

  final postsAnalytics = <MyPostModel>[].obs,
      companiesAnalytics = <MyCompanyModel>[].obs,
      usersAnalytics = <MyUserModel>[].obs,
      interactionAnalytics = <MyInteractionModel>[].obs;

  void _streamPosts() {
    _postsSubscription = FirebaseFirestore.instance
        .collection('companies')
        .doc(companyUniversalController.currentCompany.id)
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((event) {
      postsAnalytics.clear();
      postsAnalytics.addAll(event.docs.map(
        (e) => MyPostModel.fromMap(e.data()),
      ));
    });
  }

  void _streamCompanies() {
    // _companiesSubscriptions = FirebaseFirestore.instance
    //     .collection('companies')
    //     .where('companyId', isEqualTo: universalController.currentCompany.id)
    //     .orderBy('createdAt', descending: true)
    //     .snapshots()
    //     .listen((event) {
    //   companiesAnalytics.clear();
    //   companiesAnalytics.addAll(event.docs.map(
    //     (e) => MyCompanyModel.fromMap(e.data()),
    //   ));
    // });
  }

  void _streamUsers() {
    _usersSubscriptions = FirebaseFirestore.instance
        .collection('users')
        .where('companyId',
            isEqualTo: companyUniversalController.currentCompany.id)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((event) {
      usersAnalytics.clear();
      usersAnalytics.addAll(event.docs.map(
        (e) => MyUserModel.fromMap(e.data()),
      ));
    });
  }

  void _streamInteractions() {
    _interactionsSubscriptions = FirebaseFirestore.instance
        .collection('interactions')
        .where('companyId',
            isEqualTo: companyUniversalController.currentCompany.id)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((event) {
      interactionAnalytics.clear();
      interactionAnalytics.addAll(event.docs.map(
        (e) => MyInteractionModel.fromMap(e.data()),
      ));
    });
  }
}
