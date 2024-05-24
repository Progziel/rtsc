import 'dart:developer';

import 'package:animations/animations.dart';
import 'package:app/helper/colors.dart';
import 'package:app/helper/designs.dart';
import 'package:app/helper/dialog.dart';
import 'package:app/helper/my_player.dart';
import 'package:app/helper/rich_text_field.dart';
import 'package:app/helper/snackbars.dart';
import 'package:app/media/controller/posts_controller.dart';
import 'package:app/media/controller/universal_controller.dart';
import 'package:app/model/interactions_model.dart';
import 'package:app/model/post_model.dart';
import 'package:app/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

part 'interactions.dart';
part 'media.dart';
part 'post_by.dart';
part 'post_detail.dart';
part 'post_open.dart';
part 'posts_list.dart';
part 'sheet.dart';

class MyPostsPage extends StatelessWidget {
  MyPostsPage({super.key});
  final _postsController = Get.put(
      MyPostsController(Get.find<MyMediaUniversalController>().currentUser));

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => RefreshIndicator(
        color: MyColorHelper.red1,
        onRefresh: () => _postsController.loadOrRefreshPosts(),
        child: Column(
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
                          Expanded(
                            child: Center(
                                child: ListView.builder(
                              itemCount: 1,
                              itemBuilder: (context, i) => const Center(
                                  child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('No Posts found!'),
                              )),
                            )),
                          )
                        ]
                      : [Expanded(child: _MyPostsList())],
        ),
      ),
    );
  }
}
