import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:app/media/api/posts_apis.dart';
import 'package:app/model/interactions_model.dart';
import 'package:app/model/post_model.dart';
import 'package:app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class MyPostsController extends GetxController {
  MyPostsController(this.currentUser);
  final MyUserModel currentUser;
  final MyPostApis _myPostApis = MyPostApis();

  final _loadingPage = true.obs;
  String? _errorPage;
  bool get loadingPage => _loadingPage.value;
  String? get errorPage => _errorPage;
  final _posts = <MyPostModel>[].obs,
      _interactions = <MyInteractionModel>[].obs;
  List<MyPostModel> get posts => _posts;
  StreamSubscription<QuerySnapshot>? _interactionSubscription;

  @override
  void onInit() {
    loadOrRefreshPosts(load: true);
    _streamInteractions();
    super.onInit();
  }

  @override
  void onClose() {
    if (_interactionSubscription != null) _interactionSubscription!.cancel();
    super.onClose();
  }

  void _streamInteractions() {
    _interactionSubscription = FirebaseFirestore.instance
        .collection('interactions')
        // .where('companyId',
        // isEqualTo: companyUniversalController.currentCompany.id)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((event) {
      _interactions.clear();
      _interactions.addAll(
          event.docs.map((e) => MyInteractionModel.fromMap(e.data())).toList());
    });
  }

  Future<void> loadOrRefreshPosts({bool load = false}) async {
    if (load) _loadingPage.value = true;
    dynamic response = await _myPostApis.loadPosts(currentUser.id);
    _errorPage = null;
    _posts.clear();
    response.runtimeType == String
        ? _errorPage = response
        : _posts.addAll(response);

    _posts.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    if (load) _loadingPage.value = false;

    // if (await _myPostApis.getPostsToUpdate(_posts, 'posts') == null) {
    //   _posts.refresh();
    // }
  }

  List<MyInteractionModel> postLikes(int i) =>
      _interactionsList(_posts[i].id!, MyInteractionType.like);

  List<MyInteractionModel> postComments(int i) =>
      _interactionsList(_posts[i].id!, MyInteractionType.comment);

  List<MyInteractionModel> postShares(int i) =>
      _interactionsList(_posts[i].id!, MyInteractionType.share);

  List<MyInteractionModel> _interactionsList(String i, MyInteractionType t) =>
      _interactions.where((e) => (e.postId == i && e.type == t)).toList();

  ///Add or Update Post
  final QuillController titleController = QuillController.basic();
  final QuillController subtitleController = QuillController.basic();
  final QuillController descriptionController = QuillController.basic();

  ///Interaction Data
  final initialInteraction = 0.obs;
  final TextEditingController commentController = TextEditingController();
  MyInteractionModel _interactionModel(
          {required MyInteractionType type,
          required String docId,
          required String postId,
          required String companyId,
          String? data}) =>
      MyInteractionModel(
          type: type,
          id: docId,
          postId: postId,
          companyId: companyId,
          userId: currentUser.id,
          data: data);

  Future<void> onLike(int i) async {
    try {
      DocumentReference interactionReference =
          FirebaseFirestore.instance.collection('interactions').doc();
      FirebaseFirestore.instance
          .collection('interactions')
          .where('postId', isEqualTo: _posts[i].id)
          .where('type', isEqualTo: MyInteractionType.like.name)
          .where('userId', isEqualTo: currentUser.id)
          .get()
          .then((value) {
        value.docs.isEmpty
            ? interactionReference.set(_interactionModel(
                type: MyInteractionType.like,
                docId: interactionReference.id,
                postId: _posts[i].id!,
                companyId: _posts[i].companyId!,
              ).toMap())
            : value.docs.first.reference.delete();
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> onComments(int i) async {
    try {
      if (commentController.text.trim().isNotEmpty) {
        DocumentReference interactionReference =
            FirebaseFirestore.instance.collection('interactions').doc();
        interactionReference.set(_interactionModel(
          type: MyInteractionType.comment,
          docId: interactionReference.id,
          postId: _posts[i].id!,
          companyId: _posts[i].companyId!,
          data: commentController.text.trim(),
        ).toMap());
        commentController.clear();
      }
    } catch (e) {
      print(e);
    }
  }

  String getTextToShare(int i) {
    try {
      String title = extractPlainTextFromDelta(_posts[i].titleJson!);
      String subtitle = extractPlainTextFromDelta(_posts[i].subtitleJson!);
      String desc = extractPlainTextFromDelta(_posts[i].descriptionJson!);
      return '${title.trim().isNotEmpty ? 'Title: $title\n' : ''}'
          '${subtitle.trim().isNotEmpty ? 'Subtitle: $subtitle\n' : ''}'
          '${desc.trim().isNotEmpty ? 'Description: $desc\n' : ''}';
    } catch (e) {
      return 'Null text to share';
    }
  }

  String extractPlainTextFromDelta(List<dynamic> deltaJson) {
    Delta delta = Delta.fromJson(deltaJson);
    String plainText = '';
    for (final op in delta.toList()) {
      if (op.isInsert) plainText += op.data.toString();
    }

    return plainText;
  }

  String? tempFileName, tempFileExt;
  MimeType? tempMimeType;
  String? getFileUrl(int i) {
    String tempName = DateTime.now().millisecondsSinceEpoch.toString();
    if (_posts[i].imageUrl != null) {
      tempFileName = 'image-$tempName';
      tempFileExt = 'png';
      tempMimeType = MimeType.PNG;
      return _posts[i].imageUrl!;
    } else if (_posts[i].videoUrl != null) {
      tempFileName = 'video-$tempName';
      tempFileExt = 'mp4';
      tempMimeType = MimeType.MPEG;
      return _posts[i].videoUrl!;
    } else if (_posts[i].audioUrl != null) {
      tempFileName = 'audio-$tempName';
      tempFileExt = 'mp3';
      tempMimeType = MimeType.MP3;
      return _posts[i].audioUrl!;
    } else if (_posts[i].documentUrl != null) {
      tempFileName = 'doc-$tempName';
      tempFileExt = 'pdf';
      tempMimeType = MimeType.PDF;
      return _posts[i].documentUrl!;
    }
    return null;
  }

  Future<String?> saveFile(Uint8List bytes) async {
    try {
      await FileSaver.instance
          .saveAs(tempFileName!, bytes, tempFileExt!, tempMimeType!);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<XFile?> getXFileToShare(String url) async {
    try {
      Uri uri = Uri.parse(url);
      final response = await get(uri);
      String? type = response.headers['content-type'];
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      String tempName = "rtsc_file${DateTime.now().millisecondsSinceEpoch}"
          ".${type!.split('/').last}";

      File fileWrite = File("$tempPath/$tempName");
      fileWrite.writeAsBytesSync(response.bodyBytes);
      final file = XFile("$tempPath/$tempName", mimeType: type);
      return file;
    } catch (e) {
      return null;
    }
  }

  Future<void> onShare(int i, String raw) async {
    try {
      DocumentReference interactionReference =
          FirebaseFirestore.instance.collection('interactions').doc();
      interactionReference.set(_interactionModel(
              type: MyInteractionType.share,
              docId: interactionReference.id,
              postId: _posts[i].id!,
              companyId: _posts[i].companyId!,
              data: raw)
          .toMap());
    } catch (e) {
      print(e);
    }
  }

  final List<MyUserModel> interactionUsers = [];
  Future<void> getInteractionUser(String userId) async {
    if (interactionUsers.firstWhereOrNull((e) => e.id == userId) == null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get()
          .then((value) {
        if (value.data() != null) {
          interactionUsers
              .add(MyUserModel.fromMap(value.data() as Map<String, dynamic>));
        }
      });
    }
  }
}
