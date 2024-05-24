import 'package:cloud_firestore/cloud_firestore.dart';

enum MyInteractionType { like, comment, share }

class MyInteractionModel {
  MyInteractionModel(
      {this.type,
      this.id,
      this.postId,
      this.companyId,
      this.userId,
      this.data,
      this.createdAt});
  MyInteractionType? type;
  String? id, postId, companyId, userId, data;
  DateTime? createdAt;

  static MyInteractionModel fromMap(Map<String, dynamic> map) =>
      MyInteractionModel(
        type: map['type'] == 'like'
            ? MyInteractionType.like
            : map['type'] == 'comment'
                ? MyInteractionType.comment
                : map['type'] == 'share'
                    ? MyInteractionType.share
                    : null,
        id: map['id'],
        postId: map['postId'],
        companyId: map['companyId'],
        userId: map['userId'],
        data: map['data'],
        createdAt: map['createdAt']?.toDate(),
      );

  Map<String, dynamic> toMap() => {
        'type': type?.name,
        'id': id,
        'postId': postId,
        'companyId': companyId,
        'userId': userId,
        'data': data,
        'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      };
}
