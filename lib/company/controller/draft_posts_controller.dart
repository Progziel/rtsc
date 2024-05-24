import 'dart:typed_data';

import 'package:app/company/api/post_apis.dart';
import 'package:app/company/view/dashboard/screen.dart';
import 'package:app/model/post_model.dart';
import 'package:app/model/user_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:get/get.dart';

class MyDraftPostsController extends GetxController {
  final MyPostApis _myPostApis = MyPostApis();

  final _loadingPage = true.obs;
  String? _errorPage;
  bool get loadingPage => _loadingPage.value;
  String? get errorPage => _errorPage;
  final _posts = <MyPostModel>[].obs;
  List<MyPostModel> get posts => _posts;
  late MyPostModel _selectedPost;
  MyPostModel get selectedPost => _selectedPost;

  late QuillController titleController,
      subtitleController,
      descriptionController;
  final pickedImage = Rx<Uint8List?>(null);
  final pickedVideo = Rx<FilePickerResult?>(null),
      pickedAudio = Rx<FilePickerResult?>(null),
      pickedDocument = Rx<FilePickerResult?>(null);
  set setDraftPost(int v) {
    _selectedPost = _posts[v];
    titleController = QuillController.basic()
      ..setContents(Delta.fromJson(_selectedPost.titleJson!));
    subtitleController = QuillController.basic()
      ..setContents(Delta.fromJson(_selectedPost.subtitleJson!));
    descriptionController = QuillController.basic()
      ..setContents(Delta.fromJson(_selectedPost.descriptionJson!));
    pickedImage.value = null;
    pickedVideo.value = null;
    pickedAudio.value = null;
    pickedDocument.value = null;
  }

  void loadPosts() async {
    _loadingPage.value = true;
    _errorPage = null;
    _posts.clear();
    dynamic response = await _myPostApis.loadPosts(
        companyUniversalController.currentUser.companyId,
        companyUniversalController.currentUser.userType == MyUserType.prMember
            ? companyUniversalController.currentUser.id
            : null,
        draft: true);
    response.runtimeType == String
        ? _errorPage = response
        : _posts.addAll(response);
    _loadingPage.value = false;

    // if (await _myPostApis.getPostsToUpdate(_posts, draft: true) == null) {
    //   _posts.refresh();
    // }
  }

  ///Add or Update Post
  final _loadingDialog = false.obs;

  //Getters
  bool get loadingDialog => _loadingDialog.value;

  final showEmail = false.obs;
  Future<void> onPost({bool post = true}) async {
    _loadingDialog.value = true;
    dynamic response = await Future.wait([
      _myPostApis
          .createUpdateOrDraftPost(
              pickedImage.value,
              pickedVideo.value,
              pickedAudio.value,
              pickedDocument.value,
              titleController,
              subtitleController,
              descriptionController,
              companyUniversalController.currentCompany.id,
              companyUniversalController.currentCompany.companyName,
              companyUniversalController.currentUser.id,
              companyUniversalController.currentUser.fullName,
              companyUniversalController.currentUser.userType?.name,
              showEmail.value
                  ? companyUniversalController.currentUser.email
                  : null,
              companyUniversalController.currentUser.profilePicUrl,
              updatingModel: !post ? selectedPost : null,
              draft: !post ? true : false)
          .then((value) {
        if (value.runtimeType == MyPostModel && !post) {
          _posts[_posts.indexOf(_selectedPost)] = value;
        }
      }),
      if (post) _myPostApis.deletePost(_selectedPost, draft: true),
    ]);
    if (response.runtimeType != String) {
      _loadingDialog.value = false;
      if (post) _posts.remove(_selectedPost);
    }
  }

  Future<void> onDeletePost() async {
    _loadingDialog.value = true;
    await _myPostApis.deletePost(_selectedPost, draft: true);
    _posts.remove(_selectedPost);
    _loadingDialog.value = false;
  }
}
