import 'package:app/helper/colors.dart';
import 'package:app/helper/my_player.dart';
import 'package:app/helper/responsive.dart';
import 'package:app/helper/rich_text_field.dart';
import 'package:app/model/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class MyPostDetailDialog extends StatefulWidget {
  const MyPostDetailDialog(this.model, {super.key});
  final MyPostModel model;

  @override
  State<MyPostDetailDialog> createState() => _MyPostDetailDialogState();
}

class _MyPostDetailDialogState extends State<MyPostDetailDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      content: SizedBox(
        width: context.isLandscape ? context.width * 0.75 : context.width,
        height: context.height > myResponsiveHeight
            ? context.height * 0.75
            : myResponsiveHeight,
        child: DefaultTabController(
          length: 4,
          child: LayoutBuilder(
            builder: (context, constraints) => constraints.maxWidth > 700
                ? Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _title('Create'),
                            Expanded(child: _CreateSection(widget.model)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24.0),
                      Expanded(flex: 2, child: _PreviewSection(widget.model)),
                    ],
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _title('Create'),
                        _CreateSection(widget.model),
                        const SizedBox(height: 16.0),
                        SizedBox(
                          height: constraints.maxWidth * 0.90,
                          child: _PreviewSection(widget.model),
                        )
                      ],
                    ),
                  ),
          ),
        ),
      ),
      actions: [
        InkWell(
          hoverColor: Colors.transparent,
          onTap: () => Get.back(),
          child: const Text('Cancel'),
        )
      ],
    );
  }
}

BoxDecoration _boxDecoration() => BoxDecoration(
    color: MyColorHelper.black.withOpacity(0.05),
    border: Border.all(color: MyColorHelper.black.withOpacity(0.10)),
    borderRadius: const BorderRadius.all(Radius.circular(16.0)));

Widget _title(String title) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(title,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: MyColorHelper.black.withOpacity(0.60))),
    );

class _CreateSection extends StatefulWidget {
  const _CreateSection(this.model);
  final MyPostModel model;

  @override
  State<_CreateSection> createState() => _CreateSectionState();
}

class _CreateSectionState extends State<_CreateSection> {
  final QuillController title = QuillController.basic();
  final QuillController subtitle = QuillController.basic();
  final QuillController description = QuillController.basic();

  @override
  void initState() {
    title.setContents(Delta.fromJson(widget.model.titleJson ?? []));
    subtitle.setContents(Delta.fromJson(widget.model.subtitleJson ?? []));
    description.setContents(Delta.fromJson(widget.model.descriptionJson ?? []));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: _boxDecoration(),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Text('Title', style: _style()),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  color: MyColorHelper.white.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: MyColorHelper.black1.withOpacity(0.10),
                  )),
              child: MyQuillEditor(
                hints: 'Title',
                controller: title,
                readOnly: true,
              ),
            ),
            const SizedBox(height: 16.0),
            Text('Subtitle', style: _style()),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  color: MyColorHelper.white.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: MyColorHelper.black1.withOpacity(0.10),
                  )),
              child: MyQuillEditor(
                hints: 'Subtitle',
                controller: subtitle,
                readOnly: true,
              ),
            ),
            const SizedBox(height: 16.0),
            Text('Description', style: _style()),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  color: MyColorHelper.white.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: MyColorHelper.black1.withOpacity(0.10),
                  )),
              child: MyQuillEditor(
                hints: 'Description',
                controller: description,
                readOnly: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _style() => const TextStyle(
      fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black54);
}

class _PreviewSection extends StatelessWidget {
  const _PreviewSection(this.model);
  final MyPostModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title('Preview'),
        Expanded(
            child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 16.0),
                decoration: _boxDecoration(),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: model.imageUrl != null
                      ? Image.network(
                          fit: BoxFit.cover,
                          model.imageUrl!,
                        )
                      : model.videoUrl != null
                          ? MyPlayer(path: model.videoUrl!)
                          : model.audioUrl != null
                              ? MyPlayer(path: model.audioUrl!, audio: true)
                              : model.audioUrl != null
                                  ? SfPdfViewer.network(
                                      model.documentUrl!,
                                    )
                                  : Image.asset(
                                      'assets/images/default-image.png',
                                      fit: BoxFit.cover),
                ))),
      ],
    );
  }
}
