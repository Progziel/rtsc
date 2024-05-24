part of 'page.dart';

class _MyInteractions extends StatelessWidget {
  _MyInteractions(this.i);
  final int i;
  final MyPostsController controller = Get.find<MyPostsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () => controller.onLike(i),
              icon: Row(
                children: [
                  Text(controller.postLikes(i).isNotEmpty
                      ? controller.postLikes(i).length.toString()
                      : ''),
                  const SizedBox(width: 8.0),
                  Icon(
                      controller
                              .postLikes(i)
                              .map((e) => e.userId)
                              .toList()
                              .contains(controller.currentUser.id)
                          ? Icons.thumb_up_rounded
                          : Icons.thumb_up_outlined,
                      color: MyColorHelper.red1.withOpacity(0.50)),
                ],
              )),
          IconButton(
              onPressed: () {
                controller.initialInteraction.value = 1;
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) => _MyBottomSheet(i),
                );
              },
              icon: Row(
                children: [
                  Text(controller.postComments(i).isNotEmpty
                      ? controller.postComments(i).length.toString()
                      : ''),
                  const SizedBox(width: 8.0),
                  Icon(Icons.comment_outlined,
                      color: MyColorHelper.red1.withOpacity(0.50)),
                ],
              )),
          IconButton(
              onPressed: () async {
                final download = false.obs;
                String? fileUrl = controller.getFileUrl(i);
                String text = controller.getTextToShare(i);

                XFile? file;
                if (fileUrl != null) {
                  MyDialogHelper.showLoadingDialog(context,
                      text: 'Loading media to share');
                  file = await controller.getXFileToShare(fileUrl);
                  Get.back();
                  if (context.mounted) {
                    await showDialog(
                        context: context,
                        builder: (bContext) => AlertDialog(
                              title: const Text('Sharing'),
                              scrollable: true,
                              content: Column(
                                children: [
                                  const Text(
                                      'Media found with the post! For (Facebook,'
                                      ' Instagram, and WhatsApp), please download'
                                      ' and attach manually due to sharing policies.'
                                      ' Other apps will attach media directly.'),
                                  Obx(() => CheckboxListTile(
                                        value: download.value,
                                        onChanged: (value) =>
                                            download.value = !download.value,
                                        title: const Text(
                                          'Download file?',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                              actions: [
                                InkWell(
                                  onTap: () async {
                                    if (download.value && file != null) {
                                      print('object');
                                      await controller
                                          .saveFile(await file.readAsBytes());
                                    }
                                    Get.back();
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Share'),
                                  ),
                                )
                              ],
                            ));
                  }
                }

                ShareResult? result;
                try {
                  result = file != null
                      ? await Share.shareXFiles([file], text: text)
                      : await Share.shareWithResult(text);
                } catch (e) {
                  try {
                    result = await Share.shareWithResult(text);
                  } catch (ee) {
                    log(ee.toString());
                  }
                }
                if (result != null &&
                    result.status == ShareResultStatus.success) {
                  controller.onShare(i, result.raw);
                }
              },
              icon: Row(
                children: [
                  Text(controller.postShares(i).isNotEmpty
                      ? controller.postShares(i).length.toString()
                      : ''),
                  const SizedBox(width: 8.0),
                  Icon(Icons.share_outlined,
                      color: MyColorHelper.red1.withOpacity(0.50)),
                ],
              )),
        ],
      ),
    );
  }

  String extractPlainTextFromDelta(List<dynamic> deltaJson) {
    Delta delta = Delta.fromJson(deltaJson);
    String plainText = '';

    for (final op in delta.toList()) {
      if (op.isInsert) {
        plainText += op.data.toString();
      }
    }

    return plainText;
  }
}
