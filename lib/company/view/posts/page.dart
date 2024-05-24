import 'dart:html' as html;
import 'dart:typed_data';

import 'package:app/company/controller/posts_controller.dart';
import 'package:app/company/view/dashboard/screen.dart';
import 'package:app/helper/colors.dart';
import 'package:app/helper/designs.dart';
import 'package:app/helper/image_picker.dart';
import 'package:app/helper/my_player.dart';
import 'package:app/helper/responsive.dart';
import 'package:app/helper/rich_text_field.dart';
import 'package:app/helper/snackbars.dart';
import 'package:app/model/interactions_model.dart';
import 'package:app/model/post_model.dart';
import 'package:app/model/user_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

part 'create/create_dialog.dart';
part 'create/create_section.dart';
part 'create/preview_section.dart';
part 'image_and_detail.dart';
part 'interactions.dart';
part 'post_detail.dart';
part 'posts_list.dart';

class MyPostsPage extends StatefulWidget {
  const MyPostsPage({super.key});

  @override
  State<MyPostsPage> createState() => _MyPostsPageState();
}

class _MyPostsPageState extends State<MyPostsPage> {
  final _postsController = Get.put<MyPostsController>(MyPostsController());

  @override
  void dispose() {
    Get.delete<MyPostsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: (_postsController.loadingPage)
            ? const [
                Center(
                    child: CircularProgressIndicator(
                  color: MyColorHelper.red1,
                ))
              ]
            : (_postsController.errorPage != null)
                ? [
                    Center(
                        child: Text(_postsController.errorPage!,
                            overflow: TextOverflow.ellipsis))
                  ]
                : (_postsController.posts.isEmpty)
                    ? [
                        const Center(
                            child: Text('No Posts found',
                                overflow: TextOverflow.ellipsis))
                      ]
                    : [test()],
      ),
    );
  }

  Widget test() => Expanded(
        child: StreamBuilder(
          stream: _postsController.getInteractions(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              List<MyInteractionModel> interactions = snapshot.data!.docs
                  .map((e) => MyInteractionModel.fromMap(
                      e.data() as Map<String, dynamic>))
                  .toList();
              return _postsController.selectedPost != null
                  ? _MyPostDetail(
                      _postsController,
                      _getType(interactions, MyInteractionType.like,
                          postId: _postsController.selectedPost!.id),
                      _getType(interactions, MyInteractionType.comment,
                          postId: _postsController.selectedPost!.id),
                      _getType(interactions, MyInteractionType.share,
                          postId: _postsController.selectedPost!.id))
                  : _MyPostsList(
                      _postsController,
                      _getType(interactions, MyInteractionType.like),
                      _getType(interactions, MyInteractionType.comment),
                      _getType(interactions, MyInteractionType.share));
            } else {
              return const Center(
                  child: CircularProgressIndicator(
                color: MyColorHelper.red1,
              ));
            }
          },
        ),
      );

  List<MyInteractionModel> _getType(
          List<MyInteractionModel> list, MyInteractionType type,
          {String? postId}) =>
      list
          .where((element) => postId == null
              ? element.type == type
              : (element.type == type && element.postId == postId))
          .toList();
}
