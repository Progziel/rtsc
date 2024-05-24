import 'dart:typed_data';

import 'package:app/model/company_model.dart';
import 'package:app/model/interactions_model.dart';
import 'package:app/model/post_model.dart';
import 'package:app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class MyAdminUniversalController extends GetxController {
  final _tabIndex = 0.obs;
  get tabIndex => _tabIndex.value;

  final _loading = false.obs;
  String? _error;
  bool get loading => _loading.value;
  String? get error => _error;
  final _companies = <MyCompanyModel>[].obs;
  List<MyCompanyModel> get companies => _companies;

  void setTabIndex(int v) {
    _clearData();
    _tabIndex.value = v;
    if (_tabIndex.value == 1) {
      _loadCompanies(null);
    } else if (_tabIndex.value == 2) {
      _loadCompanies(true);
    } else if (_tabIndex.value == 3) {
      _loadCompanies(false);
    }
  }

  void _loadCompanies(bool? status) async {
    _loading.value = true;
    _error = null;
    try {
      Query companiesQuery = FirebaseFirestore.instance
          .collection('companies')
          .orderBy('createdAt', descending: true);
      status == null
          ? companiesQuery = companiesQuery.where('status', isNull: true)
          : companiesQuery = companiesQuery.where('status', isEqualTo: status);
      await companiesQuery.get().then((value) {
        _companies.clear();
        _companies.addAll(value.docs.map(
            (e) => MyCompanyModel.fromMap(e.data() as Map<String, dynamic>)));
      });
    } on FirebaseException catch (e) {
      _error = e.code;
    } catch (e) {
      _error = 'Error: ${e.toString()}';
    }
    _loading.value = false;
  }

  ///Selected Company
  final _selectedCompany = Rx<MyCompanyModel?>(null);
  MyCompanyModel? get selectedCompany => _selectedCompany.value;
  set setSelectedCompany(MyCompanyModel? v) => _selectedCompany.value = v;
  final List<MyUserModel> users = [];
  final List<MyPostModel> posts = [];
  final List<MyInteractionModel> interactions = [];

  void _clearData() {
    _selectedCompany.value = null;
    users.clear();
    posts.clear();
  }

  Future<void> loadCompanyData() async {
    try {
      await Future.wait([
        FirebaseFirestore.instance
            .collection('users')
            .where('companyId', isEqualTo: _selectedCompany.value!.id)
            .get()
            .then((value) {
          users.clear();
          users.addAll(value.docs.map((e) => MyUserModel.fromMap(e.data())));
        }),
        FirebaseFirestore.instance
            .collection('companies')
            .doc(_selectedCompany.value!.id)
            .collection('posts')
            .orderBy('createdAt', descending: true)
            .get()
            .then((value) {
          posts.clear();
          posts.addAll(value.docs.map((e) => MyPostModel.fromMap(e.data())));
        }),
        FirebaseFirestore.instance
            .collection('interactions')
            .where('companyId', isEqualTo: _selectedCompany.value!.id)
            .orderBy('createdAt', descending: true)
            .get()
            .then((value) {
          interactions.clear();
          interactions.addAll(
              value.docs.map((e) => MyInteractionModel.fromMap(e.data())));
        }),
      ]);
    } catch (e) {
      // _error = 'Error: ${e.toString()}';
    }
  }

  Future<String?> onCompanyAction(MyCompanyModel model) async {
    try {
      await FirebaseFirestore.instance
          .collection('companies')
          .doc(model.id)
          .update({
        'register': model.register,
        'status': model.status,
      }).then((value) => _companies.remove(model));
      return null;
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  ///Profile
  final profilePicUrl = Rx<String?>(null);

  void loadProfilePic() async {
    profilePicUrl.value = await FirebaseStorage.instance
        .ref()
        .child('logos')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .getDownloadURL();
  }

  Future<String?> updateProfile(Uint8List bytes) async {
    try {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('logos')
          .child(FirebaseAuth.instance.currentUser!.uid);
      await ref.putData(bytes, SettableMetadata(contentType: 'image/png'));
      String url = await ref.getDownloadURL();
      profilePicUrl.value = url.startsWith('https://') ? url : null;
      return null;
    } on FirebaseException catch (e) {
      return e.code;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  Future<String?> changePassword(
      String currentPassword, String newPassword) async {
    try {
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(EmailAuthProvider.credential(
              email: FirebaseAuth.instance.currentUser!.email!,
              password: currentPassword))
          .then((value) async => await value.user!.updatePassword(newPassword));
      return null;
    } on FirebaseException catch (e) {
      return e.code;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }
}
