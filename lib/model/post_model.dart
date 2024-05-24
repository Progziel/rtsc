import 'package:cloud_firestore/cloud_firestore.dart';

class MyPostModel {
  MyPostModel({
    this.id,
    this.titleJson,
    this.subtitleJson,
    this.descriptionJson,
    this.companyId,
    this.companyName,
    this.userId,
    this.userName,
    this.userType,
    this.userEmail,
    this.userProfilePicUrl,
    this.imageUrl,
    this.videoUrl,
    this.videoThumbnailUrl,
    this.audioUrl,
    this.documentUrl,
    this.createdAt,
  });
  List<dynamic>? titleJson, subtitleJson, descriptionJson;
  String? id, companyId, companyName, userId, userName, userType, userEmail;
  String? userProfilePicUrl, imageUrl, audioUrl, documentUrl;
  String? videoUrl, videoThumbnailUrl;
  DateTime? createdAt;

  static MyPostModel fromMap(Map<String, dynamic> map) => MyPostModel(
        id: map['id'],
        titleJson: map['titleJson'],
        subtitleJson: map['subtitleJson'],
        descriptionJson: map['descriptionJson'],
        companyId: map['companyId'],
        companyName: map['companyName'],
        userId: map['userId'],
        userName: map['userName'],
        userType: map['userType'],
        userEmail: map['userEmail'],
        userProfilePicUrl: map['userProfilePicUrl'],
        imageUrl: map['imageUrl'],
        videoThumbnailUrl: map['videoThumbnailUrl'],
        videoUrl: map['videoUrl'],
        audioUrl: map['audioUrl'],
        documentUrl: map['documentUrl'],
        createdAt: map['createdAt']?.toDate(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'titleJson': titleJson,
        'subtitleJson': subtitleJson,
        'descriptionJson': descriptionJson,
        'companyId': companyId,
        'companyName': companyName,
        'userId': userId,
        'userName': userName,
        'userType': userType,
        'userEmail': userEmail,
        'userProfilePicUrl': userProfilePicUrl,
        'imageUrl': imageUrl,
        'videoThumbnailUrl': videoThumbnailUrl,
        'videoUrl': videoUrl,
        'audioUrl': audioUrl,
        'documentUrl': documentUrl,
        'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      };
}
