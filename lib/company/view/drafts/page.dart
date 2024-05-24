import 'dart:html' as html;
import 'dart:typed_data';

import 'package:app/company/controller/draft_posts_controller.dart';
import 'package:app/company/view/dashboard/screen.dart';
import 'package:app/helper/buttons/buttons.dart';
import 'package:app/helper/colors.dart';
import 'package:app/helper/image_picker.dart';
import 'package:app/helper/my_player.dart';
import 'package:app/helper/responsive.dart';
import 'package:app/helper/rich_text_field.dart';
import 'package:app/model/post_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

part 'image_and_detail.dart';
part 'posts_list.dart';
part 'update/preview_section.dart';
part 'update/update_dialog.dart';
part 'update/update_section.dart';

class MyDraftPostsPage extends StatefulWidget {
  const MyDraftPostsPage({super.key});

  @override
  State<MyDraftPostsPage> createState() => _MyDraftPostsPageState();
}

class _MyDraftPostsPageState extends State<MyDraftPostsPage> {
  final _draftPostsController = MyDraftPostsController();

  @override
  void initState() {
    _draftPostsController.loadPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: (_draftPostsController.loadingPage)
            ? const [
                Center(
                    child: CircularProgressIndicator(
                  color: MyColorHelper.red1,
                ))
              ]
            : (_draftPostsController.errorPage != null)
                ? [
                    Center(
                        child: Text(_draftPostsController.errorPage!,
                            overflow: TextOverflow.ellipsis))
                  ]
                : (_draftPostsController.posts.isEmpty)
                    ? [
                        const Center(
                            child: Text('No Posts found',
                                overflow: TextOverflow.ellipsis))
                      ]
                    : [
                        Expanded(
                          child: _MyDraftPostsList(
                              controller: _draftPostsController),
                        )
                      ],
      ),
    );
  }
}
