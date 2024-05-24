import 'dart:html' as html;
import 'dart:typed_data';

import 'package:app/company/view/dashboard/screen.dart';
import 'package:app/model/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:mime/mime.dart';
import 'package:uuid/uuid.dart';

class MyPostApis {
  String collection = 'posts';

  Future<dynamic> loadPosts(String? companyId, String? userId,
      {bool draft = false}) async {
    try {
      List<MyPostModel> list = [];
      Query query = FirebaseFirestore.instance
          .collection('companies')
          .doc(companyUniversalController.currentCompany.id)
          .collection(draft ? 'draft_posts' : collection)
          .orderBy('createdAt', descending: true);

      // if (userId != null) {
      //   query = query.where('userId', isEqualTo: userId);
      // }

      await query.get().then((value) {
        list.clear();
        list.addAll(value.docs
            .map((e) => MyPostModel.fromMap(e.data() as Map<String, dynamic>)));
      });
      return list;
    } on FirebaseException catch (e) {
      return e.code;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  // Future<String?> getPostsToUpdate(List<MyPostModel> posts,
  //     {bool draft = false}) async {
  //   try {
  //     final users = <MyUserModel>[], companies = <MyCompanyModel>[];
  //     List<String> userIds = posts
  //         .map((element) => element.userId != null ? element.userId! : '')
  //         .toSet()
  //         .toList();
  //     List<String> companyIds = posts
  //         .map((element) => element.companyId != null ? element.companyId! : '')
  //         .toSet()
  //         .toList();
  //     await Future.wait([
  //       FirebaseFirestore.instance
  //           .collection('users')
  //           .where('id', whereIn: userIds)
  //           .get()
  //           .then((value) {
  //         users.clear();
  //         users.addAll(value.docs.map((e) => MyUserModel.fromMap(e.data())));
  //       }),
  //       FirebaseFirestore.instance
  //           .collection('companies')
  //           .where('id', whereIn: companyIds)
  //           .get()
  //           .then((value) {
  //         companies.clear();
  //         companies
  //             .addAll(value.docs.map((e) => MyCompanyModel.fromMap(e.data())));
  //       }),
  //     ]);
  //
  //     final postsToUpdate = <MyPostModel>[];
  //     for (MyPostModel post in posts) {
  //       MyUserModel? userModel =
  //           users.firstWhereOrNull((element) => element.id == post.userId);
  //       MyCompanyModel? companyModel = companies
  //           .firstWhereOrNull((element) => element.id == post.companyId);
  //       if (userModel != null && companyModel != null) {
  //         if ((post.userName != userModel.fullName ||
  //                 post.userProfilePicUrl != userModel.profilePicUrl) ||
  //             post.companyName != companyModel.companyName) {
  //           post.userName = userModel.fullName;
  //           post.userProfilePicUrl = userModel.profilePicUrl;
  //           post.companyName = companyModel.companyName;
  //           postsToUpdate.add(post);
  //         }
  //       }
  //     }
  //
  //     await Future.wait(postsToUpdate
  //         .map((e) => FirebaseFirestore.instance
  //             .collection('companies')
  //             .doc(companyUniversalController.currentCompany.id)
  //             .collection(draft ? 'draft_posts' : collection)
  //             .doc(e.id)
  //             .update(e.toMap()))
  //         .toList());
  //
  //     return null;
  //   } on FirebaseException catch (e) {
  //     return e.code;
  //   } catch (e) {
  //     return 'Error: ${e.toString()}';
  //   }
  // }

  Future<dynamic> createUpdateOrDraftPost(
      Uint8List? pickedImage,
      FilePickerResult? pickedVideo,
      FilePickerResult? pickedAudio,
      FilePickerResult? pickedDocument,
      QuillController titleController,
      QuillController subtitleController,
      QuillController descriptionController,
      String? companyId,
      String? companyName,
      String? userId,
      String? userName,
      String? userType,
      String? userEmail,
      String? userProfilePicUrl,
      {MyPostModel? updatingModel,
      required bool draft}) async {
    try {
      dynamic quillMediaResponse = await _uploadQuillMedia(
          titleController, subtitleController, descriptionController);
      dynamic response = await _uploadFiles(
          pickedImage, pickedVideo, pickedAudio, pickedDocument);
      if (response.runtimeType == String ||
          quillMediaResponse.runtimeType == String) {
        return response;
      } else if (response.length == 5 && quillMediaResponse.length == 3) {
        DocumentReference reference = (draft && updatingModel != null)
            ? FirebaseFirestore.instance
                .collection('companies')
                .doc(companyUniversalController.currentCompany.id)
                .collection('draft_posts')
                .doc(updatingModel.id)
            : draft
                ? FirebaseFirestore.instance
                    .collection('companies')
                    .doc(companyUniversalController.currentCompany.id)
                    .collection('draft_posts')
                    .doc()
                : updatingModel == null
                    ? FirebaseFirestore.instance
                        .collection('companies')
                        .doc(companyUniversalController.currentCompany.id)
                        .collection(collection)
                        .doc()
                    : FirebaseFirestore.instance
                        .collection('companies')
                        .doc(companyUniversalController.currentCompany.id)
                        .collection(collection)
                        .doc(updatingModel.id);
        MyPostModel model = MyPostModel(
            id: reference.id,
            titleJson: quillMediaResponse[0],
            subtitleJson: quillMediaResponse[1],
            descriptionJson: quillMediaResponse[2],
            companyId: companyId,
            companyName: companyName,
            userId: userId,
            userName: userName,
            userEmail: userEmail,
            userType: userType,
            userProfilePicUrl: userProfilePicUrl,
            imageUrl: updatingModel == null
                ? response[0]
                : response[0] ?? updatingModel.imageUrl,
            videoUrl: updatingModel == null
                ? response[1]
                : response[1] ?? updatingModel.videoUrl,
            videoThumbnailUrl: updatingModel == null
                ? response[2]
                : response[2] ?? updatingModel.videoThumbnailUrl,
            audioUrl: updatingModel == null
                ? response[3]
                : response[3] ?? updatingModel.audioUrl,
            documentUrl: updatingModel == null
                ? response[4]
                : response[4] ?? updatingModel.documentUrl,
            createdAt: updatingModel?.createdAt);
        await reference.set(model.toMap());
        DocumentSnapshot snapshot = await reference.get();
        model.createdAt =
            ((snapshot.data() as Map<String, dynamic>)['createdAt'])?.toDate();
        return model;
      } else {
        return 'File Uploading Error';
      }
    } on FirebaseException catch (e) {
      return e.code;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  Future<dynamic> _uploadQuillMedia(
      QuillController titleController,
      QuillController subtitleController,
      QuillController descriptionController) async {
    List<dynamic> title = titleController.document.toDelta().toJson();
    List<dynamic> subtitle = subtitleController.document.toDelta().toJson();
    List<dynamic> desc = descriptionController.document.toDelta().toJson();

    await processJsonList(titleController.document.toDelta().toJson());
    await processJsonList(subtitleController.document.toDelta().toJson());
    await processJsonList(descriptionController.document.toDelta().toJson());
    return [title, subtitle, desc];
  }

  Future<void> processJsonList(List<dynamic> jsonList) async {
    List<Future> futures = [];
    for (var item in jsonList) {
      if (item is Map<String, dynamic> && item.containsKey('insert')) {
        var insertData = item['insert'];
        if (insertData is Map<String, dynamic> &&
            insertData.containsKey('image')) {
          Uint8List image = await _fetchBlobData(insertData['image']);
          futures.add(_uploadData('images', image, 'image/png').then((value) =>
              value.startsWith('https://')
                  ? insertData['image'] = value
                  : null));
        }
      }
    }
    await Future.wait(futures);
  }

  Future<Uint8List> _fetchBlobData(String blobUrl) async {
    final response =
        await html.HttpRequest.request(blobUrl, responseType: 'arraybuffer');
    final buffer = response.response as ByteBuffer;
    return Uint8List.view(buffer);
  }

  Future<dynamic> _uploadFiles(
      Uint8List? pickedImage,
      FilePickerResult? pickedVideo,
      FilePickerResult? pickedAudio,
      FilePickerResult? pickedDocument) async {
    String? error, imageUrl, videoUrl, videoThumbnailUrl, audioUrl, docUrl;
    try {
      await Future.wait([
        if (pickedImage != null)
          _uploadData('images', pickedImage, 'image/png').then((value) =>
              value.startsWith('https://') ? imageUrl = value : error = value),
        if (_checkFile(pickedVideo))
          _uploadData('videos', pickedVideo!.files.first.bytes!,
                  lookupMimeType(pickedVideo.files.first.name)!)
              .then((value) async {
            if (value.startsWith('https://')) {
              videoUrl = value;
              Uint8List? thumbnail = await VideoThumbnail.thumbnailData(
                  video: value, imageFormat: ImageFormat.PNG);
              await _uploadData('images', thumbnail, 'image/png').then(
                  (value) => value.startsWith('https://')
                      ? videoThumbnailUrl = value
                      : error = value);
            } else {
              error = value;
            }
          }),
        if (_checkFile(pickedAudio))
          _uploadData('audios', pickedAudio!.files.first.bytes!,
                  lookupMimeType(pickedAudio.files.first.name)!)
              .then((value) => value.startsWith('https://')
                  ? audioUrl = value
                  : error = value),
        if (_checkFile(pickedDocument))
          _uploadData('documents', pickedDocument!.files.first.bytes!,
                  'application/pdf')
              .then((value) => value.startsWith('https://')
                  ? docUrl = value
                  : error = value),
      ]);
    } on FirebaseException catch (e) {
      error = e.code;
    } catch (e) {
      error = 'Error: ${e.toString()}';
    }
    return error ?? [imageUrl, videoUrl, videoThumbnailUrl, audioUrl, docUrl];
  }

  bool _checkFile(FilePickerResult? pickedFile) =>
      pickedFile != null &&
      pickedFile.files.isNotEmpty &&
      pickedFile.files.first.bytes != null &&
      pickedFile.files.first.bytes!.isNotEmpty;

  Future<String> _uploadData(
      String fileName, Uint8List data, String contentType) async {
    try {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child(fileName)
          .child(const Uuid().v4());
      SettableMetadata metadata = SettableMetadata(contentType: contentType);
      await ref.putData(data, metadata);
      String url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      return e.code;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  Future<String?> deletePost(MyPostModel model, {bool draft = false}) async {
    try {
      await FirebaseFirestore.instance
          .collection('companies')
          .doc(companyUniversalController.currentCompany.id)
          .collection('deleted_posts')
          .doc(model.id)
          .set(model.toMap())
          .then((value) async => await FirebaseFirestore.instance
              .collection('companies')
              .doc(companyUniversalController.currentCompany.id)
              .collection(draft ? 'draft_posts' : collection)
              .doc(model.id)
              .delete());
      return null;
    } on FirebaseException catch (e) {
      return e.code;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }
}
