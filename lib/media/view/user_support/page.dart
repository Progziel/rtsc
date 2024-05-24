import 'dart:async';

import 'package:animations/animations.dart';
import 'package:app/essentials/contact_info.dart';
import 'package:app/helper/buttons/buttons.dart';
import 'package:app/helper/colors.dart';
import 'package:app/helper/designs.dart';
import 'package:app/helper/dialog.dart';
import 'package:app/helper/snackbars.dart';
import 'package:app/model/user_model.dart';
import 'package:app/model/user_support.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

part 'messages.dart';
part 'new.dart';

class MyUserSupportPage extends StatelessWidget {
  MyUserSupportPage({super.key, this.currentUser});
  final MyUserModel? currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MyContactInfo(),
          Expanded(
            child: StreamBuilder(
              stream: stream(),
              builder: (bContext, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: MyColorHelper.red1,
                  ));
                } else {
                  final List<MyUserSupportModel> chats = [];
                  if (!snapshot.hasError &&
                      snapshot.hasData &&
                      snapshot.data != null &&
                      snapshot.data!.docs.isNotEmpty) {
                    chats.addAll(snapshot.data!.docs.map((e) =>
                        MyUserSupportModel.fromMap(
                            e.data() as Map<String, dynamic>)));
                  }
                  print(chats);
                  return ListView.separated(
                    padding: EdgeInsets.all(8.0),
                    itemCount: chats.length,
                    itemBuilder: (iContext, i) => OpenContainer(
                        closedBuilder: (cContext, action) => ListTile(
                              onTap: action,
                              dense: true,
                              title: Text(
                                'Subject: ${chats[i].subject}',
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'Message: ${chats[i].lastMessage}',
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    chats[i].createdAt != null
                                        ? DateFormat('MM-dd-yyyy')
                                            .format(chats[i].createdAt!)
                                        : '',
                                    style: const TextStyle(
                                        fontSize: 11, color: Colors.black54),
                                  ),
                                  Text(
                                    chats[i].createdAt != null
                                        ? DateFormat('hh:mm a')
                                            .format(chats[i].createdAt!)
                                        : '',
                                    style: const TextStyle(
                                        fontSize: 11, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                        openBuilder: (oContext, action) =>
                            _MyMessagesScreen(currentUser!, chats[i])),
                    separatorBuilder: (sContext, i) => SizedBox(height: 8.0),
                  );
                }
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
          backgroundColor: MyColorHelper.red1.withOpacity(0.75),
          foregroundColor: MyColorHelper.white,
          child: Icon(Icons.chat_rounded),
          onPressed: () => showDialog(
                context: context,
                builder: (bContext) => AlertDialog(
                  scrollable: true,
                  content: _MyAddNewChat(currentUser: currentUser),
                ),
              )),
    );
  }

  Stream<QuerySnapshot>? stream() => FirebaseFirestore.instance
      .collection('user_support')
      .where('senderId', isEqualTo: currentUser?.id)
      .orderBy('createdAt', descending: true)
      .snapshots();
}
