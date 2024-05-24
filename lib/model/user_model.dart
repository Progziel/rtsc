import 'package:cloud_firestore/cloud_firestore.dart';

enum MyUserType { superAdmin, admin, user, prMember, mediaMember }

class MyUserModel {
  MyUserModel({
    this.id,
    this.email,
    this.password,
    this.fullName,
    this.phone,
    this.companyId,
    this.profilePicUrl,
    this.mediaOutletName,
    this.userType,
    this.status,
    this.followings,
    this.notifications,
    this.createdAt,
  });
  String? id,
      email,
      password,
      fullName,
      phone,
      companyId,
      profilePicUrl,
      mediaOutletName;
  MyUserType? userType;
  bool? status;
  DateTime? createdAt;
  List<String>? followings, notifications;

  static MyUserModel fromMap(Map<String, dynamic> map) => MyUserModel(
        id: map['id'],
        email: map['email'],
        password: map['password'],
        fullName: map['fullName'],
        phone: map['phone'],
        companyId: map['companyId'],
        profilePicUrl: map['profilePicUrl'],
        mediaOutletName: map['mediaOutletName'],
        userType: _stringToUserType(map['userType']),
        status: map['status'],
        followings: map['followings'] != null
            ? List<String>.from(map['followings'])
            : null,
        notifications: map['notifications'] != null
            ? List<String>.from(map['notifications'])
            : null,
        createdAt: map['createdAt']?.toDate(),
      );

  static MyUserType? _stringToUserType(String? type) =>
      type == MyUserType.admin.name
          ? MyUserType.admin
          : type == MyUserType.user.name
              ? MyUserType.user
              : type == MyUserType.prMember.name
                  ? MyUserType.prMember
                  : type == MyUserType.mediaMember.name
                      ? MyUserType.mediaMember
                      : null;

  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'password': password,
        'fullName': fullName,
        'phone': phone,
        'userType': userType?.name,
        'profilePicUrl': profilePicUrl,
        'mediaOutletName': mediaOutletName,
        if (userType != MyUserType.mediaMember) 'status': status,
        if (userType != MyUserType.mediaMember) 'companyId': companyId,
        if (userType == MyUserType.mediaMember) 'followings': followings ?? [],
        if (userType == MyUserType.mediaMember)
          'notifications': notifications ?? [],
        'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      };
}
