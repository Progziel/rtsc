import 'package:cloud_firestore/cloud_firestore.dart';

class MyCompanyModel {
  MyCompanyModel(
      {this.id,
      this.createdAt,
      this.companyName,
      this.ownerName,
      this.description,
      this.email,
      this.logoUrl,
      this.status,
      this.register,
      this.followers});
  String? id, companyName, ownerName, description, email, logoUrl;
  bool? status, register;
  List<String>? followers;
  DateTime? createdAt;

  static MyCompanyModel fromMap(Map<String, dynamic> map) => MyCompanyModel(
        id: map['id'],
        companyName: map['companyName'],
        ownerName: map['ownerName'],
        description: map['description'],
        // mailingAddress: map['mailingAddress'],
        // phone: map['phone'],
        email: map['email'],
        logoUrl: map['logoUrl'],
        status: map['status'],
        register: map['register'],
        followers: List<String>.from(map['followers']),
        createdAt: map['createdAt']?.toDate(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'companyName': companyName,
        'ownerName': ownerName,
        'description': description,
        // 'mailingAddress': mailingAddress,
        // 'phone': phone,
        'email': email,
        'logoUrl': logoUrl,
        'status': status,
        'register': register,
        'followers': followers,
        'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      };
}
