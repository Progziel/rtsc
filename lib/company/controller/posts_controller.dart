import 'dart:typed_data';

import 'package:app/company/api/post_apis.dart';
import 'package:app/company/view/dashboard/screen.dart';
import 'package:app/model/interactions_model.dart';
import 'package:app/model/post_model.dart';
import 'package:app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:get/get.dart';

class MyPostsController extends GetxController {
  final MyPostApis _myPostApis = MyPostApis();

  final _loadingPage = true.obs;
  String? _errorPage;
  bool get loadingPage => _loadingPage.value;
  String? get errorPage => _errorPage;
  final _posts = <MyPostModel>[].obs;
  List<MyPostModel> get posts => _posts;
  double _offSet = 0.0;
  double get offSet => _offSet;
  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  @override
  void onInit() {
    _loadPosts();
    super.onInit();
  }

  void _loadPosts() async {
    _loadingPage.value = true;
    _errorPage = null;
    _posts.clear();
    dynamic response = await _myPostApis.loadPosts(
      companyUniversalController.currentUser.companyId,
      companyUniversalController.currentUser.userType == MyUserType.prMember
          ? companyUniversalController.currentUser.id
          : null,
    );
    response.runtimeType == String
        ? _errorPage = response
        : _posts.addAll(response);
    _loadingPage.value = false;

    // if (await _myPostApis.getPostsToUpdate(_posts) == null) {
    //   _posts.refresh();
    // }
  }

  final _selectedPost = Rx<MyPostModel?>(null);
  MyPostModel? get selectedPost => _selectedPost.value;
  void setSelectedPost(MyPostModel? post) async {
    if (_scrollController.hasClients) {
      _offSet = _scrollController.offset;
    }
    landscapeMode.value = true;
    _loadingPage.value = true;
    if (post != null) {
      companyUniversalController.setActionButtonText = 'Edit Post';
      titleController.setContents(Delta.fromJson(post.titleJson ?? []));
      subtitleController.setContents(Delta.fromJson(post.subtitleJson ?? []));
      descriptionController
          .setContents(Delta.fromJson(post.descriptionJson ?? []));
      await Future.delayed(500.milliseconds);
    } else {
      companyUniversalController.setActionButtonText = 'Create Post';
      titleController.clear();
      subtitleController.clear();
      descriptionController.clear();
    }
    _errorPage = null;
    _selectedPost.value = post;
    _loadingPage.value = false;

    if (post == null) {
      await Future.delayed(5.milliseconds);
      if (_scrollController.hasClients) _scrollController.jumpTo(_offSet);
    }
  }

  ///Add or Update Post
  final _loadingDialog = false.obs;
  final QuillController titleController = QuillController.basic(),
      subtitleController = QuillController.basic(),
      descriptionController = QuillController.basic();
  final pickedImage = Rx<Uint8List?>(null);
  final pickedVideo = Rx<FilePickerResult?>(null),
      pickedAudio = Rx<FilePickerResult?>(null),
      pickedDocument = Rx<FilePickerResult?>(null);

  //Getters
  bool get loadingDialog => _loadingDialog.value;

  final showEmail = false.obs;
  Future<String?> createUpdateOrDraftPost({bool draft = false}) async {
    _loadingDialog.value = true;
    dynamic response = await _myPostApis.createUpdateOrDraftPost(
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
        showEmail.value ? companyUniversalController.currentUser.email : null,
        companyUniversalController.currentUser.profilePicUrl,
        updatingModel: _selectedPost.value,
        draft: draft);
    _loadingDialog.value = false;
    if (response.runtimeType == MyPostModel) {
      if (!draft) {
        if (_selectedPost.value == null) {
          _posts.insert(0, response);
          clearAll();
        } else {
          _posts[_posts.indexOf(_selectedPost.value)] = response;
          _selectedPost.value = response;
        }
      }
    }
    return response.runtimeType == String ? response : null;
  }

  Future<String?> deletePost() async {
    _loadingDialog.value = true;
    String? response = await _myPostApis.deletePost(_selectedPost.value!);
    _loadingDialog.value = false;
    if (response == null) {
      _posts.removeAt(_posts.indexOf(_selectedPost.value));
      setSelectedPost(null);
      clearAll();
    }
    return response;
  }

  void clearAll() {
    titleController.clear();
    subtitleController.clear();
    descriptionController.clear();
    pickedImage.value = null;
    pickedVideo.value = null;
    pickedAudio.value = null;
    pickedDocument.value = null;
  }

  ///Interaction Data
  int initialInteraction = 0;
  final landscapeMode = true.obs;
  final TextEditingController comments = TextEditingController();
  MyInteractionModel _interactionModel(
          {required MyInteractionType type,
          required String docId,
          required String postId,
          String? comment}) =>
      MyInteractionModel(
          type: type,
          id: docId,
          postId: postId,
          companyId: companyUniversalController.currentCompany.id,
          userId: companyUniversalController.currentUser.id,
          data: comment);

  Future<void> onLike(int i) async {
    try {
      DocumentReference interactionReference =
          FirebaseFirestore.instance.collection('interactions').doc();
      FirebaseFirestore.instance
          .collection('interactions')
          .where('postId', isEqualTo: _posts[i].id)
          .where('type', isEqualTo: MyInteractionType.like.name)
          .where('userId', isEqualTo: companyUniversalController.currentUser.id)
          .get()
          .then((value) {
        value.docs.isEmpty
            ? interactionReference.set(_interactionModel(
                type: MyInteractionType.like,
                docId: interactionReference.id,
                postId: _posts[i].id!,
              ).toMap())
            : value.docs.first.reference.delete();
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> onComments(int i) async {
    if (comments.text.trim().isNotEmpty) {
      try {
        DocumentReference interactionReference =
            FirebaseFirestore.instance.collection('interactions').doc();
        interactionReference.set(_interactionModel(
          type: MyInteractionType.comment,
          docId: interactionReference.id,
          postId: _posts[i].id!,
          comment: comments.text.trim(),
        ).toMap());
        comments.clear();
      } catch (e) {
        print(e);
      }
    }
  }

  // Future<void> onShare(int i) async {
  //   try {
  //     DocumentReference interactionReference =
  //         FirebaseFirestore.instance.collection('interactions').doc();
  //     interactionReference.set(_interactionModel(
  //             type: MyInteractionType.share,
  //             docId: interactionReference.id,
  //             postId: _posts[i].id!)
  //         .toMap());
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Stream<QuerySnapshot> getInteractions() => FirebaseFirestore.instance
      .collection('interactions')
      // .where('companyId', isEqualTo: universalController.currentCompany.id)
      .orderBy('createdAt', descending: true)
      .snapshots();

  Future<DocumentSnapshot> getInteractionUser(String userId) =>
      FirebaseFirestore.instance.collection('users').doc(userId).get();
}
