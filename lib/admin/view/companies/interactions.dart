import 'package:app/helper/colors.dart';
import 'package:app/model/interactions_model.dart';
import 'package:app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyCompanyDetailPostsInteractionsAdmin extends StatelessWidget {
  MyCompanyDetailPostsInteractionsAdmin(
      {required this.index,
      required this.likes,
      required this.comments,
      required this.shares});
  final int index;
  final List<MyInteractionModel> likes, comments, shares;
  final _users = <MyUserModel>[].obs;
  // final comment = 0.obs;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      content: SizedBox(
        width: 500,
        height: 600,
        child: DefaultTabController(
          initialIndex: index,
          length: 3,
          child: Column(
            children: [
              TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: MyColorHelper.black.withOpacity(0.10),
                indicatorColor: MyColorHelper.red1.withOpacity(0.75),
                labelColor: MyColorHelper.red1.withOpacity(0.75),
                tabs: [
                  Tab(
                    icon: const Icon(Icons.thumb_up_outlined),
                    text: likes.isNotEmpty ? likes.length.toString() : null,
                  ),
                  Tab(
                      icon: const Icon(Icons.comment_outlined),
                      text: comments.isNotEmpty
                          ? comments.length.toString()
                          : null),
                  Tab(
                    icon: const Icon(Icons.share_outlined),
                    text: shares.isNotEmpty ? shares.length.toString() : null,
                  ),
                ],
              ),
              Expanded(
                child: ColoredBox(
                  color: MyColorHelper.red1.withOpacity(0.01),
                  child: TabBarView(
                    children: [
                      likes.isEmpty
                          ? _notFound('likes')
                          : _interactions(likes, MyInteractionType.like),
                      comments.isEmpty
                          ? _notFound('Comments')
                          : _interactions(comments, MyInteractionType.comment),
                      shares.isEmpty
                          ? _notFound('shares')
                          : _interactions(shares, MyInteractionType.share),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _notFound(String string) => Center(child: Text('No $string found!!!'));

  Widget _interactions(List<MyInteractionModel> list, MyInteractionType type) =>
      Obx(() => ListView.builder(
            reverse: type == MyInteractionType.comment ? true : false,
            padding: EdgeInsets.all(_users.isEmpty ? 4.0 : 4.0),
            itemCount: list.length,
            itemBuilder: (context, i) => _users
                        .firstWhereOrNull((e) => e.id == list[i].userId!) ==
                    null
                ? FutureBuilder(
                    future: _getInteractionUser(list[i].userId!),
                    builder: (context, snapshot) {
                      MyUserModel? interactionUser = _users
                          .firstWhereOrNull((e) => e.id == list[i].userId!);
                      interactionUser ??= MyUserModel(id: list[i].userId);
                      return _interactionTile(type, interactionUser, list[i]);
                    },
                  )
                : _interactionTile(type,
                    _users.firstWhere((e) => e.id == list[i].userId!), list[i]),
            // _interactionTile(type, list[i]),
          ));

  Widget _interactionTile(MyInteractionType type, MyUserModel user,
          MyInteractionModel interactionModel) =>
      type == MyInteractionType.comment
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _profile(user.profilePicUrl, true),
                _comment(user.fullName, interactionModel.data),
              ],
            )
          : Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                  color: MyColorHelper.white.withOpacity(0.85),
                  border:
                      Border.all(color: MyColorHelper.red1.withOpacity(0.15)),
                  borderRadius: BorderRadius.circular(8.0)),
              child: ListTile(
                dense: true,
                leading: _profile(user.profilePicUrl, true),
                title: Text(user.fullName ?? 'Null',
                    overflow: TextOverflow.ellipsis),
                subtitle:
                    Text(user.email ?? 'Null', overflow: TextOverflow.ellipsis),
              ),
            );

  Widget _profile(String? url, bool show) => Opacity(
        opacity: show ? 1.0 : 0.0,
        child: CircleAvatar(
          radius: 20,
          backgroundColor: MyColorHelper.red1.withOpacity(0.05),
          backgroundImage: url == null
              ? const AssetImage('assets/images/default-profile.png')
              : null,
          foregroundImage: url != null ? NetworkImage(url) : null,
        ),
      );

  Widget _comment(String? name, String? comment) => Expanded(
        child: Container(
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
              color: MyColorHelper.red1.withOpacity(0.05),
              border: Border.all(color: MyColorHelper.red1.withOpacity(0.15)),
              borderRadius: BorderRadius.only(
                  topRight: const Radius.circular(8.0),
                  bottomLeft: const Radius.circular(8.0),
                  bottomRight: const Radius.circular(8.0))),
          child: ListTile(
            dense: true,
            title: Text(
              name ?? 'Null',
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(textAlign: TextAlign.left, comment ?? 'Null'),
          ),
        ),
      );

  Future<void> _getInteractionUser(String userId) async {
    if (_users.firstWhereOrNull((e) => e.id == userId) == null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get()
          .then((value) {
        if (value.data() != null) {
          _users.add(MyUserModel.fromMap(value.data() as Map<String, dynamic>));
        }
      });
    }
  }
}
