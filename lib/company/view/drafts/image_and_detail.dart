part of 'page.dart';

class _MyImage extends StatelessWidget {
  const _MyImage({required this.model});
  final MyPostModel model;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 16 / 9,
        child: (model.imageUrl != null &&
                model.imageUrl!.startsWith('https://'))
            ? Image.network(model.imageUrl!, fit: BoxFit.cover)
            : (model.videoThumbnailUrl != null &&
                    model.videoThumbnailUrl!.startsWith('https://'))
                ? Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('assets/images/video_banner.png'),
                    )),
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: NetworkImage(model.videoThumbnailUrl!),
                      )),
                      child: ColoredBox(
                        color: MyColorHelper.black1.withOpacity(0.25),
                        child: Center(
                          child: Icon(
                            color: MyColorHelper.white.withOpacity(0.75),
                            Icons.play_circle_outline_rounded,
                            size: 75.0,
                          ),
                        ),
                      ),
                    ),
                  )
                : model.audioUrl != null
                    ? Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('assets/images/audio_banner.png'),
                        )),
                        child: ColoredBox(
                          color: MyColorHelper.black1.withOpacity(0.25),
                          child: Center(
                            child: Icon(
                              color: MyColorHelper.white.withOpacity(0.75),
                              Icons.play_circle_outline_rounded,
                              size: 75.0,
                            ),
                          ),
                        ),
                      )
                    : model.documentUrl != null
                        ? Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: AssetImage(
                                'assets/images/document_banner.png',
                              ),
                            )),
                            child: ColoredBox(
                              color: MyColorHelper.black1.withOpacity(0.25),
                              child: Center(
                                child: Icon(
                                  color: MyColorHelper.white.withOpacity(0.50),
                                  Icons.remove_red_eye_outlined,
                                  size: 75.0,
                                ),
                              ),
                            ),
                          )
                        : Image.asset('assets/images/default-image.png',
                            fit: BoxFit.cover));
  }
}

class _MyDetail extends StatelessWidget {
  const _MyDetail({required this.model, required this.height});
  final MyPostModel model;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 64,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                (model.titleJson != null)
                    ? SizedBox(
                        height: 24,
                        child: MyQuillEditor(
                            controller: QuillController.basic()
                              ..setContents(Delta.fromJson(model.titleJson!)),
                            readOnly: true,
                            textStyles: const DefaultStyles(
                              paragraph: DefaultTextBlockStyle(
                                TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20),
                                VerticalSpacing(0, 0),
                                VerticalSpacing(0, 0),
                                null,
                              ),
                            )),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(height: 4.0),
                (model.subtitleJson != null)
                    ? SizedBox(
                        height: 20,
                        child: MyQuillEditor(
                            controller: QuillController.basic()
                              ..setContents(
                                  Delta.fromJson(model.subtitleJson!)),
                            readOnly: true,
                            textStyles: const DefaultStyles(
                              paragraph: DefaultTextBlockStyle(
                                TextStyle(color: Colors.white, fontSize: 16),
                                VerticalSpacing(0, 0),
                                VerticalSpacing(0, 0),
                                null,
                              ),
                            )),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          color: MyColorHelper.white.withOpacity(0.75),
          height: height - 64,
          child: (model.descriptionJson != null)
              ? MyQuillEditor(
                  controller: QuillController.basic()
                    ..setContents(Delta.fromJson(model.descriptionJson!)),
                  readOnly: true)
              : null,
        )
      ],
    );
  }
}
