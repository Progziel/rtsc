import 'package:app/admin/view/companies/interactions.dart';
import 'package:app/admin/view/dashboard/screen.dart';
import 'package:app/admin/view/dialogs/post_detail.dart';
import 'package:app/helper/colors.dart';
import 'package:app/helper/rich_text_field.dart';
import 'package:app/model/company_model.dart';
import 'package:app/model/interactions_model.dart';
import 'package:app/model/post_model.dart';
import 'package:app/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:intl/intl.dart';

import 'dialog.dart';

class MyCompanyDetail extends StatelessWidget {
  const MyCompanyDetail({super.key, required this.model, this.request = false});
  final MyCompanyModel model;
  final bool request;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
              color: MyColorHelper.black1,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              )),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _close(),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: MyColorHelper.red1.withOpacity(0.08),
                              ),
                              color: MyColorHelper.red1.withOpacity(0.05),
                              image: model.logoUrl != null
                                  ? DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(model.logoUrl!))
                                  : const DecorationImage(
                                      image: AssetImage(
                                      'assets/images/default-company-logo.png',
                                    )),
                            ),
                          ),
                          ...[
                            Text(
                              model.companyName ?? 'Null',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: MyColorHelper.white,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Owner\' Name: ${model.ownerName ?? 'Null'}',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: MyColorHelper.white,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    _close(context: context),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: DefaultTabController(
            length: !request ? 3 : 1,
            child: Column(
              children: [
                TabBar(
                  labelColor: MyColorHelper.red1,
                  indicatorColor: MyColorHelper.red1,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: MyColorHelper.black1.withOpacity(0.10),
                  tabs: [
                    const Tab(text: 'Detail'),
                    if (!request) ...[
                      const Tab(text: 'Users'),
                      const Tab(text: 'Posts'),
                    ],
                  ],
                ),
                Expanded(
                    child: TabBarView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            _detailItem(
                                'Created At',
                                DateFormat('MM-dd-yyyy | hh:mm a')
                                    .format(model.createdAt!)),
                            // _detailItem('Mailing Address',
                            //     model.mailingAddress ?? 'Null'),
                            // _detailItem('Phone', model.phone ?? 'Null'),
                            _detailItem('Email', model.email ?? 'Null'),
                            _detailItem('Followers',
                                '${model.followers != null ? model.followers!.length : '0'}'),
                            _detailItem(
                                'Description', model.description ?? 'Null'),
                          ],
                        ),
                      ),
                    ),
                    if (!request) ...[
                      _users(adminUniversalController.users),
                      _posts(adminUniversalController.posts,
                          adminUniversalController.interactions),
                    ],
                  ],
                ))
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _close({BuildContext? context}) => IconButton(
      onPressed: () {
        if (context == null) {
          adminUniversalController.setSelectedCompany = null;
        } else {
          showDialog(context: context, builder: (context) => MyDialog(model));
        }
      },
      icon: Icon(
        context == null ? Icons.close_rounded : Icons.more_vert,
        color: MyColorHelper.white,
      ));

  Widget _detailItem(String str1, String str2) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$str1: ',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Expanded(child: Text(str2)),
          ],
        ),
      );

  Widget _users(List<MyUserModel> users) => ListView.separated(
        padding: const EdgeInsets.all(8.0),
        itemCount: users.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              contentPadding: const EdgeInsets.all(8.0),
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: MyColorHelper.black1.withOpacity(0.50),
                  ),
                  borderRadius: BorderRadius.circular(8.0)),
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: MyColorHelper.red1.withOpacity(0.08),
                  ),
                  color: MyColorHelper.red1.withOpacity(0.05),
                  image: users[i].profilePicUrl != null
                      ? DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            users[i].profilePicUrl!,
                          ))
                      : const DecorationImage(
                          image: AssetImage(
                          'assets/images/default-profile.png',
                        )),
                ),
              ),
              title: Text('${users[i].fullName ?? 'Null'} '
                  '(${users[i].userType == null ? 'Null' : users[i].userType! == MyUserType.admin ? 'Admin' : users[i].userType! == MyUserType.user ? 'Management User' : users[i].userType! == MyUserType.prMember ? 'PR Member' : 'Null'})'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email: ${users[i].email ?? 'Null'}',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Phone: ${users[i].phone ?? 'Null'}',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              // onTap: () => showAddUserDialog(context, model: list[i]),
              trailing: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  color: users[i].status == null
                      ? Colors.blue.withOpacity(0.75)
                      : users[i].status!
                          ? Colors.green.withOpacity(0.75)
                          : Colors.red.withOpacity(0.75),
                ),
                child: Text(
                  users[i].status == null
                      ? 'Null'
                      : users[i].status!
                          ? 'Active'
                          : 'Inactive',
                  style:
                      const TextStyle(fontSize: 14, color: MyColorHelper.white),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, i) => const Divider(),
      );

  Widget _posts(
          List<MyPostModel> posts, List<MyInteractionModel> interactions) =>
      ListView.separated(
        padding: const EdgeInsets.all(8.0),
        itemCount: posts.length,
        itemBuilder: (context, i) {
          List<MyInteractionModel> likes = interactions
              .where((e) =>
                  e.postId == posts[i].id && e.type == MyInteractionType.like)
              .toList();
          List<MyInteractionModel> comments = interactions
              .where((e) =>
                  e.postId == posts[i].id &&
                  e.type == MyInteractionType.comment)
              .toList();
          List<MyInteractionModel> shares = interactions
              .where((e) =>
                  e.postId == posts[i].id && e.type == MyInteractionType.share)
              .toList();
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 24.0, horizontal: 32.0),
              decoration: BoxDecoration(
                  color: MyColorHelper.white.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(32.0)),
              child: Column(
                children: [
                  ListTile(
                    onTap: () => showDialog(
                        context: context,
                        builder: (context) => MyPostDetailDialog(posts[i])),
                    contentPadding: const EdgeInsets.all(8.0),
                    shape: InputBorder.none,
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: MyColorHelper.red1.withOpacity(0.08),
                        ),
                        color: MyColorHelper.red1.withOpacity(0.05),
                        image: posts[i].userProfilePicUrl != null
                            ? DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  posts[i].userProfilePicUrl!,
                                ))
                            : const DecorationImage(
                                image: AssetImage(
                                'assets/images/default-profile.png',
                              )),
                      ),
                    ),
                    title: Text('Posted By: ${posts[i].userName ?? 'r'}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (posts[i].titleJson != null)
                            ? SizedBox(
                                height: 18,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: MyQuillEditor(
                                          controller: QuillController.basic()
                                            ..setContents(Delta.fromJson(
                                                posts[i].titleJson!)),
                                          readOnly: true,
                                          textStyles: const DefaultStyles(
                                            paragraph: DefaultTextBlockStyle(
                                              TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black54),
                                              VerticalSpacing(4.0, 0),
                                              VerticalSpacing(0, 0),
                                              null,
                                            ),
                                          )),
                                    ),
                                    const Text('...'),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                        (posts[i].subtitleJson != null)
                            ? SizedBox(
                                height: 18,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: MyQuillEditor(
                                          controller: QuillController.basic()
                                            ..setContents(Delta.fromJson(
                                                posts[i].subtitleJson!)),
                                          readOnly: true,
                                          textStyles: const DefaultStyles(
                                            paragraph: DefaultTextBlockStyle(
                                              TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black54),
                                              VerticalSpacing(4.0, 0),
                                              VerticalSpacing(0, 0),
                                              null,
                                            ),
                                          )),
                                    ),
                                    const Text('...'),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                        // MyQuillEditor(
                        //   hints: 'Subtitle',
                        //   controller: QuillController.basic()
                        //     ..setContents(
                        //         Delta.fromJson(list[i].subtitleJson ?? [])),
                        //   readOnly: true,
                        // ),
                      ],
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(DateFormat('MM-dd-yyyy')
                            .format(posts[i].createdAt!)),
                        Text(
                          DateFormat('hh:mm a').format(posts[i].createdAt!),
                          style: const TextStyle(fontSize: 10.0),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => showDialog(
                              context: context,
                              builder: (bContext) =>
                                  MyCompanyDetailPostsInteractionsAdmin(
                                    index: 0,
                                    likes: likes,
                                    comments: comments,
                                    shares: shares,
                                  )),
                          child: Row(
                            children: [
                              Text(
                                  likes.isEmpty ? '' : likes.length.toString()),
                              const SizedBox(width: 8.0),
                              Icon(Icons.thumb_up_outlined,
                                  color: MyColorHelper.red1.withOpacity(0.50)),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () => showDialog(
                              context: context,
                              builder: (bContext) =>
                                  MyCompanyDetailPostsInteractionsAdmin(
                                    index: 1,
                                    likes: likes,
                                    comments: comments,
                                    shares: shares,
                                  )),
                          child: Row(
                            children: [
                              Text(comments.isEmpty
                                  ? ''
                                  : comments.length.toString()),
                              const SizedBox(width: 8.0),
                              Icon(Icons.comment_outlined,
                                  color: MyColorHelper.red1.withOpacity(0.50)),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () => showDialog(
                              context: context,
                              builder: (bContext) =>
                                  MyCompanyDetailPostsInteractionsAdmin(
                                    index: 2,
                                    likes: likes,
                                    comments: comments,
                                    shares: shares,
                                  )),
                          child: Row(
                            children: [
                              Text(shares.isEmpty
                                  ? ''
                                  : shares.length.toString()),
                              const SizedBox(width: 8.0),
                              Icon(Icons.share_outlined,
                                  color: MyColorHelper.red1.withOpacity(0.50)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, i) => const Divider(),
      );
}
