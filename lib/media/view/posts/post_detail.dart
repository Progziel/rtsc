part of 'page.dart';

class _PostDetail extends StatelessWidget {
  _PostDetail(this.i, {this.short = true});
  final int i;
  final bool short;
  final MyPostsController controller = Get.find<MyPostsController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (controller.posts[i].titleJson != null)
            short
                ? Text(
                    controller
                        .extractPlainTextFromDelta(
                            controller.posts[i].titleJson!)
                        .trim(),
                    style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  )
                : MyQuillEditor(
                    controller: QuillController.basic()
                      ..setContents(
                          Delta.fromJson(controller.posts[i].titleJson!)),
                    readOnly: true),
          if (controller.posts[i].subtitleJson != null) ...[
            if (controller.posts[i].titleJson != null)
              const SizedBox(height: 4.0),
            short
                ? Text(
                    controller
                        .extractPlainTextFromDelta(
                            controller.posts[i].subtitleJson!)
                        .trim(),
                    style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 13),
                  )
                : MyQuillEditor(
                    controller: QuillController.basic()
                      ..setContents(
                          Delta.fromJson(controller.posts[i].subtitleJson!)),
                    readOnly: true)
          ],
          if (controller.posts[i].descriptionJson != null) ...[
            if (controller.posts[i].titleJson != null ||
                controller.posts[i].subtitleJson != null)
              const SizedBox(height: 4.0),
            ...short
                ? [
                    Text(
                      controller
                          .extractPlainTextFromDelta(
                              controller.posts[i].descriptionJson!)
                          .trim(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    )
                  ]
                : _description(context)
          ],
        ],
      ),
    );
  }

  List<Widget> _description(BuildContext context) {
    List<Widget> description = [];
    description.add(const Divider());
    final RegExp pattern =
        RegExp(r'https://www\.youtube\.com/watch\?v=([a-zA-Z0-9_-]+)');
    List<dynamic> part = [];
    List<Widget> widgets = [];
    for (final element in controller.posts[i].descriptionJson!) {
      if (element['attributes'] != null &&
          element['attributes']['link'] != null &&
          pattern.hasMatch(element['attributes']['link'])) {
        if (part.isNotEmpty) {
          widgets.add(MyQuillEditor(
              controller: QuillController.basic()
                ..setContents(Delta.fromJson(part)),
              readOnly: true));
          part = [];
        }
        description.addAll(widgets);
        widgets = [];
        widgets.add(Center(
          child: SizedBox(
            width: context.width * 0.75,
            child: YoutubePlayer(
              controller: YoutubePlayerController.fromVideoId(
                videoId: pattern
                    .firstMatch(element['attributes']['link'])!
                    .group(1)!,
                autoPlay: false,
                params: const YoutubePlayerParams(showFullscreenButton: true),
              ),
              aspectRatio: 16 / 9,
            ),
          ),
        ));
      } else {
        part.add(element);
      }
    }
    if (part.isNotEmpty) {
      widgets.add(MyQuillEditor(
          controller: QuillController.basic()
            ..setContents(Delta.fromJson(part)),
          readOnly: true));
    }
    description.addAll(widgets);
    return description;
  }
}
