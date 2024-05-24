import 'package:app/model/company_model.dart';
import 'package:app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class MyMediaMembersController extends GetxController {
  MyMediaMembersController(this.currentUser);
  final MyUserModel currentUser;

  final _loading = true.obs;
  String? _error;
  bool get loading => _loading.value;
  String? get error => _error;
  final _mediaMembers = <MyUserModel>[].obs;
  List<MyUserModel> get mediaMembers => _mediaMembers;

  @override
  void onInit() {
    _loadMediaMembers();
    super.onInit();
  }

  void _loadMediaMembers() async {
    _loading.value = true;
    _error = null;
    try {
      await FirebaseFirestore.instance
          .collection('companies')
          .doc(currentUser.companyId)
          .get()
          .then((value) async {
        MyCompanyModel companyModel = MyCompanyModel.fromMap(value.data()!);
        CollectionReference reference =
            FirebaseFirestore.instance.collection('users');
        if (companyModel.followers != null &&
            companyModel.followers!.isNotEmpty) {
          await reference
              .where(FieldPath.documentId, whereIn: companyModel.followers)
              .get()
              .then((value) {
            _mediaMembers.clear();
            _mediaMembers.addAll(value.docs.map(
                (e) => MyUserModel.fromMap(e.data() as Map<String, dynamic>)));
          });
        }
      });
    } on FirebaseAuthException catch (e) {
      _error = e.code;
    } catch (e) {
      _error = 'Error: ${e.toString()}';
    }
    _loading.value = false;
  }

  List<MyUserModel> get followers => _mediaMembers
      .where((e) => e.followings!.contains(currentUser.companyId))
      .toList();

  List<MyUserModel> get requests => _mediaMembers
      .where((e) => !(e.followings!.contains(currentUser.companyId)))
      .toList();

  Future<String?> onAccept(MyUserModel model) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(model.id)
          .update({
        'followings': FieldValue.arrayUnion([currentUser.companyId])
      }).then((value) {
        model.followings!.insert(0, currentUser.companyId!);
        _mediaMembers.refresh();
      });
      return null;
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  Future<String?> onReject(MyUserModel model) async {
    try {
      await FirebaseFirestore.instance
          .collection('companies')
          .doc(currentUser.companyId)
          .update({
        'followers': FieldValue.arrayRemove([model.id])
      }).then((value) => _mediaMembers.remove(model));
      return null;
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  Future<String?> onUnFollow(MyUserModel model) async {
    try {
      await Future.wait([
        FirebaseFirestore.instance.collection('users').doc(model.id).update({
          'followings': FieldValue.arrayRemove([currentUser.companyId])
        }),
        FirebaseFirestore.instance
            .collection('companies')
            .doc(currentUser.companyId)
            .update({
          'followers': FieldValue.arrayRemove([model.id])
        })
      ]);
      _mediaMembers.remove(model);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }
}
