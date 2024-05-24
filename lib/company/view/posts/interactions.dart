part of 'page.dart';

class _MyInteractions extends StatelessWidget {
  const _MyInteractions(this.controller, this.i,
      {this.landscape = true,
      required this.likes,
      required this.comments,
      required this.shares});
  final MyPostsController controller;
  final int i;
  final bool landscape;
  final List<MyInteractionModel> likes, comments, shares;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () => controller.onLike(i),
            icon: Row(
              children: [
                Text(likes.isNotEmpty ? likes.length.toString() : ''),
                const SizedBox(width: 8.0),
                Icon(
                    likes
                            .map((e) => e.userId)
                            .toList()
                            .contains(companyUniversalController.currentUser.id)
                        ? Icons.thumb_up_rounded
                        : Icons.thumb_up_outlined,
                    color: MyColorHelper.red1.withOpacity(0.50)),
              ],
            )),
        IconButton(
            onPressed: () {
              controller.initialInteraction = 1;
              landscape
                  ? controller.setSelectedPost(controller.posts[i])
                  : controller.landscapeMode.value = false;
            },
            icon: Row(
              children: [
                Text(comments.isNotEmpty ? comments.length.toString() : ''),
                const SizedBox(width: 8.0),
                Icon(Icons.comment_outlined,
                    color: MyColorHelper.red1.withOpacity(0.50)),
              ],
            )),
        IconButton(
            onPressed: () async {
              controller.initialInteraction = 2;
              landscape
                  ? controller.setSelectedPost(controller.posts[i])
                  : controller.landscapeMode.value = false;
              // await Share.share(
              //   'Title: ${extractPlainTextFromDelta(controller.posts[i].titleJson!)}\n'
              //   'Subtitle: ${extractPlainTextFromDelta(controller.posts[i].subtitleJson!)}\n\n'
              //   'Description: ${extractPlainTextFromDelta(controller.posts[i].descriptionJson!)}',
              // );
              // controller.onShare(i);
            },
            icon: Row(
              children: [
                Text(shares.isNotEmpty ? shares.length.toString() : ''),
                const SizedBox(width: 8.0),
                Icon(Icons.share_outlined,
                    color: MyColorHelper.red1.withOpacity(0.50)),
              ],
            )),
      ],
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
