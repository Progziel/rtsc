import 'dart:async';

import 'package:app/model/company_model.dart';
import 'package:app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class MyCompaniesController extends GetxController {
  MyCompaniesController(this.currentUser);
  final MyUserModel currentUser;
  final _loading = true.obs;
  String? _error;
  bool get loading => _loading.value;
  String? get error => _error;
  final _companies = <MyCompanyModel>[].obs;
  List<MyCompanyModel> get companies => _companies;

  StreamSubscription<DocumentSnapshot>? _companiesSubscriptions;

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
        .listen((value) async => _loadCompanies(
            MyUserModel.fromMap(value.data() as Map<String, dynamic>)));
  }

  @override
  void onClose() {
    if (_companiesSubscriptions != null) _companiesSubscriptions!.cancel();
    super.onClose();
  }

  void _loadCompanies(MyUserModel mediaMember) async {
    _error = null;
    try {
      await FirebaseFirestore.instance
          .collection('companies')
          .where('status', isEqualTo: true)
          .get()
          .then((value) {
        _companies.clear();
        for (DocumentSnapshot snapshot in value.docs) {
          MyCompanyModel company =
              MyCompanyModel.fromMap(snapshot.data() as Map<String, dynamic>);
          if (mediaMember.followings != null &&
              company.followers != null &&
              !(company.followers!.contains(mediaMember.id) &&
                  mediaMember.followings!.contains(company.id))) {
            _companies.add(company);
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

  Future<String?> onFollowUnFollow(MyCompanyModel model) async {
    try {
      await FirebaseFirestore.instance
          .collection('companies')
          .doc(model.id)
          .update({
        'followers': model.followers!.contains(currentUser.id!)
            ? FieldValue.arrayRemove([currentUser.id!])
            : FieldValue.arrayUnion([currentUser.id!])
      }).then((value) {
        model.followers!.contains(currentUser.id!)
            ? model.followers!.remove(currentUser.id!)
            : model.followers!.add(currentUser.id!);
        _companies.refresh();
      });
      return null;
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }
}
