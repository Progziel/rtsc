part of 'page.dart';

class _PostMedia extends StatelessWidget {
  const _PostMedia(this.postModel, {this.short = true});
  final MyPostModel postModel;
  final bool short;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          child: (postModel.imageUrl != null &&
                  postModel.imageUrl!.startsWith('https://'))
              ? InkWell(
                  onTap: short ? null : () => Get.to(() => _MyMedia(postModel)),
                  child: Image.network(postModel.imageUrl!, fit: BoxFit.cover),
                )
              : (postModel.videoThumbnailUrl != null &&
                      postModel.videoThumbnailUrl!.startsWith('https://'))
                  ? InkWell(
                      onTap: short
                          ? null
                          : () => Get.to(() => _MyMedia(postModel)),
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('assets/images/video_banner.png'),
                        )),
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: NetworkImage(postModel.videoThumbnailUrl!),
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
                      ),
                    )
                  : (postModel.audioUrl != null)
                      ? InkWell(
                          onTap: short
                              ? null
                              : () => Get.to(() => _MyMedia(postModel)),
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image:
                                  AssetImage('assets/images/audio_banner.png'),
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
                      : (postModel.documentUrl != null)
                          ? InkWell(
                              onTap: short
                                  ? null
                                  : () => Get.to(() => _MyMedia(postModel)),
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/document_banner.png'),
                                )),
                                child: ColoredBox(
                                  color: MyColorHelper.black1.withOpacity(0.25),
                                  child: Center(
                                    child: Icon(
                                      color:
                                          MyColorHelper.white.withOpacity(0.75),
                                      Icons.remove_red_eye_outlined,
                                      size: 60.0,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Image.asset('assets/images/default-image.png',
                              fit: BoxFit.cover),
          // child: short
          //     ? (postModel.imageUrl != null &&
          //             postModel.imageUrl!.startsWith('https://'))
          //         ? Image.network(postModel.imageUrl!, fit: BoxFit.cover)
          //         : (postModel.videoThumbnailUrl != null &&
          //                 postModel.videoThumbnailUrl!.startsWith('https://'))
          //             ? Container(
          //                 decoration: BoxDecoration(
          //                     image: DecorationImage(
          //                   image: NetworkImage(postModel.videoThumbnailUrl!),
          //                 )),
          //                 child: ColoredBox(
          //                   color: MyColorHelper.black1.withOpacity(0.25),
          //                   child: Center(
          //                     child: Icon(
          //                       color: MyColorHelper.white.withOpacity(0.75),
          //                       Icons.play_circle_outline_rounded,
          //                       size: 75.0,
          //                     ),
          //                   ),
          //                 ),
          //               )
          //             : (postModel.audioUrl != null)
          //                 ? Image.asset('assets/images/audio_banner.png',
          //                     fit: BoxFit.cover)
          //                 : (postModel.documentUrl != null)
          //                     ? Image.asset('assets/images/document_banner.png',
          //                         fit: BoxFit.cover)
          //                     : Image.asset('assets/images/default-image.png',
          //                         fit: BoxFit.cover)
          //     : postModel.imageUrl != null
          //         ? Image.network(fit: BoxFit.cover, postModel.imageUrl!)
          //         : postModel.videoUrl != null
          //             ? MyPlayer(path: postModel.videoUrl!)
          //             : postModel.audioUrl != null
          //                 ? MyPlayer(path: postModel.audioUrl!)
          //                 : postModel.documentUrl != null
          //                     ? SfPdfViewer.network(postModel.documentUrl!)
          //                     : Image.asset(
          //                         'assets/images/default-image.png',
          //                         fit: BoxFit.cover,
          //                       ),
        ));
  }
}

class _MyMedia extends StatelessWidget {
  _MyMedia(this.postModel);
  final MyPostModel postModel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColorHelper.red1,
          foregroundColor: MyColorHelper.white,
          title: Text('Back to post'),
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: postModel.documentUrl != null
              ? SfPdfViewer.network(postModel.documentUrl!)
              : postModel.videoUrl != null
                  ? MyPlayer(path: postModel.videoUrl!)
                  : postModel.audioUrl != null
                      ? MyPlayer(path: postModel.audioUrl!, audio: true)
                      : AspectRatio(
                          aspectRatio: 16 / 9,
                          child: postModel.imageUrl != null
                              ? Image.network(
                                  fit: BoxFit.cover, postModel.imageUrl!)
                              : Image.asset(
                                  'assets/images/default-image.png',
                                  fit: BoxFit.cover,
                                ),
                        ),
        ),
      ),
    );
  }
}
