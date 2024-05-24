import 'dart:typed_data';

import 'package:app/company/api/users_apis.dart';
import 'package:app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class MyUsersController extends GetxController {
  MyUsersController(this.currentUser);
  final MyUserModel currentUser;

  final _loading = true.obs;
  String? _error;
  bool get loading => _loading.value;
  String? get error => _error;
  final _users = <MyUserModel>[].obs;
  List<MyUserModel> get users => _users;
  late MyUserApis _myUserApis;

  @override
  void onInit() {
    _loadUsers();
    super.onInit();
  }

  void _loadUsers() async {
    _myUserApis = MyUserApis(currentUser);
    _loading.value = true;
    _error = null;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .where('companyId', isEqualTo: currentUser.companyId)
          .get()
          .then((value) {
        _users.clear();
        _users.addAll(value.docs.map((e) => MyUserModel.fromMap(e.data())));
      });
      _loading.value = false;
      return null;
    } on FirebaseAuthException catch (e) {
      _error = e.code;
    } catch (e) {
      _error = 'Error: ${e.toString()}';
    }
  }

  ///Users Section
  Future<String?> addUser(MyUserModel model, Uint8List? pic) async {
    String? string = await _myUserApis.addNewUser(model, pic);
    if (string == null) _users.insert(0, model);
    return string;
  }

  Future<String?> updateUser(int i, MyUserModel model, Uint8List? pic) async {
    String? string = await _myUserApis.updateUser(model, pic);
    if (string == null) _users[i] = model;
    return string;
  }

  Future<String?> removeUser(MyUserModel model) async {
    String? string = await _myUserApis.removeUser(model);
    if (string == null) _users.remove(model);
    return string;
  }
}
