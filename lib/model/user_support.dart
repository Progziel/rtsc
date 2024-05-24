import 'package:cloud_firestore/cloud_firestore.dart';

class MyUserSupportModel {
  MyUserSupportModel(
      {this.chatId,
      this.senderId,
      this.subject,
      this.lastMessage,
      this.createdAt});
  String? chatId, senderId, subject, lastMessage;
  DateTime? createdAt;

  Map<String, dynamic> toMap() => {
        'chatId': chatId,
        'senderId': senderId,
        'subject': subject,
        'lastMessage': lastMessage,
        'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      };

  static MyUserSupportModel fromMap(Map<String, dynamic> map) =>
      MyUserSupportModel(
        chatId: map['chatId'],
        senderId: map['senderId'],
        subject: map['subject'],
        lastMessage: map['lastMessage'],
        createdAt: map['createdAt']?.toDate(),
      );
}

class MyMessageModel {
  MyMessageModel({this.messageId, this.senderId, this.message, this.createdAt});
  String? messageId, senderId, message;
  DateTime? createdAt;

  Map<String, dynamic> toMap() => {
        'messageId': messageId,
        'senderId': senderId,
        'message': message,
        'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      };

  static MyMessageModel fromMap(Map<String, dynamic> map) => MyMessageModel(
        messageId: map['messageId'],
        senderId: map['senderId'],
        message: map['message'],
        createdAt: map['createdAt']?.toDate(),
      );
}
