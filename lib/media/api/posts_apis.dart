import 'package:app/model/company_model.dart';
import 'package:app/model/post_model.dart';
import 'package:app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class MyPostApis {
  Future<dynamic> loadPosts(String? mediaMemberId) async {
    try {
      List<MyPostModel> list = [];
      await FirebaseFirestore.instance
          .collection('users')
          .doc(mediaMemberId!)
          .get()
          .then((value) async {
        MyUserModel mediaMember =
            MyUserModel.fromMap(value.data() as Map<String, dynamic>);
        if (mediaMember.followings != null &&
            mediaMember.followings!.isNotEmpty) {
          await FirebaseFirestore.instance
              .collectionGroup('posts')
              .get()
              .then((value) async {
            list.clear();
            for (DocumentSnapshot snapshot in value.docs) {
              MyPostModel post =
                  MyPostModel.fromMap(snapshot.data() as Map<String, dynamic>);
              if (mediaMember.followings!.contains(post.companyId)) {
                list.add(post);
              }
            }
          });
        }
      });
      return list;
    } on FirebaseException catch (e) {
      return e.code;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  Future<String?> getPostsToUpdate(
      List<MyPostModel> posts, String collection) async {
    try {
      final users = <MyUserModel>[], companies = <MyCompanyModel>[];
      List<String> userIds = posts
          .map((element) => element.userId != null ? element.userId! : '')
          .toSet()
          .toList();
      List<String> companyIds = posts
          .map((element) => element.companyId != null ? element.companyId! : '')
          .toSet()
          .toList();
      await Future.wait([
        FirebaseFirestore.instance
            .collection('users')
            .where('id', whereIn: userIds)
            .get()
            .then((value) {
          users.clear();
          users.addAll(value.docs.map((e) => MyUserModel.fromMap(e.data())));
        }),
        FirebaseFirestore.instance
            .collection('companies')
            .where('id', whereIn: companyIds)
            .get()
            .then((value) {
          companies.clear();
          companies
              .addAll(value.docs.map((e) => MyCompanyModel.fromMap(e.data())));
        }),
      ]);

      final postsToUpdate = <MyPostModel>[];
      for (MyPostModel post in posts) {
        MyUserModel? userModel =
            users.firstWhereOrNull((element) => element.id == post.userId);
        MyCompanyModel? companyModel = companies
            .firstWhereOrNull((element) => element.id == post.companyId);
        if (userModel != null && companyModel != null) {
          if ((post.userName != userModel.fullName ||
                  post.userProfilePicUrl != userModel.profilePicUrl) ||
              post.companyName != companyModel.companyName) {
            post.userName = userModel.fullName;
            post.userProfilePicUrl = userModel.profilePicUrl;
            post.companyName = companyModel.companyName;
            postsToUpdate.add(post);
          }
        }
      }

      await Future.wait(postsToUpdate
          .map((e) => FirebaseFirestore.instance
              .collection(collection)
              .doc(e.id)
              .update(e.toMap()))
          .toList());

      return null;
    } on FirebaseException catch (e) {
      return e.code;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }
}
