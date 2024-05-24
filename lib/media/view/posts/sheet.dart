part of 'page.dart';

class _MyBottomSheet extends StatelessWidget {
  _MyBottomSheet(this.i);
  final int i;
  final MyPostsController controller = Get.find<MyPostsController>();
  // final comment = 0.obs;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height * 0.85,
      child: Scaffold(
        body: DefaultTabController(
          initialIndex: controller.initialInteraction.value,
          length: 3,
          child: Obx(
            () => Column(
              children: [
                TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: MyColorHelper.black.withOpacity(0.10),
                  onTap: (int i) => controller.initialInteraction.value = i,
                  indicatorColor: MyColorHelper.red1.withOpacity(0.75),
                  labelColor: MyColorHelper.red1.withOpacity(0.75),
                  tabs: [
                    Tab(
                        icon: const Icon(Icons.thumb_up_outlined),
                        text: controller.postLikes(i).isNotEmpty
                            ? controller.postLikes(i).length.toString()
                            : null),
                    Tab(
                        icon: const Icon(Icons.comment_outlined),
                        text: controller.postComments(i).isNotEmpty
                            ? controller.postComments(i).length.toString()
                            : null),
                    Tab(
                        icon: const Icon(Icons.share_outlined),
                        text: controller.postShares(i).isNotEmpty
                            ? controller.postShares(i).length.toString()
                            : null),
                  ],
                ),
                Expanded(
                  child: ColoredBox(
                    color: MyColorHelper.red1.withOpacity(0.01),
                    child: TabBarView(
                      children: [
                        controller.postLikes(i).isEmpty
                            ? _notFound('likes')
                            : _interactions(controller.postLikes(i),
                                MyInteractionType.like),
                        controller.postComments(i).isEmpty
                            ? _notFound('Comments')
                            : _interactions(controller.postComments(i),
                                MyInteractionType.comment),
                        controller.postShares(i).isEmpty
                            ? _notFound('shares')
                            : _interactions(controller.postShares(i),
                                MyInteractionType.share),
                      ],
                    ),
                  ),
                ),
                controller.initialInteraction.value == 1
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: controller.commentController,
                                decoration:
                                    MyDecorationHelper.textFieldDecoration(
                                        hints: 'Comment here...',
                                        borderColor: MyColorHelper.black
                                            .withOpacity(0.15)),
                              ),
                            ),
                            const SizedBox(width: 4.0),
                            IconButton(
                                onPressed: () => controller.onComments(i),
                                icon: Icon(
                                  Icons.send,
                                  color: MyColorHelper.black.withOpacity(0.50),
                                ))
                          ],
                        ),
                      )
                    : const SizedBox.shrink()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _notFound(String string) => Center(child: Text('No $string found!!!'));

  Widget _interactions(List<MyInteractionModel> list, MyInteractionType type) =>
      ListView.builder(
        reverse: type == MyInteractionType.comment ? true : false,
        padding: const EdgeInsets.all(4.0),
        itemCount: list.length,
        itemBuilder: (context, i) => controller.interactionUsers
                    .firstWhereOrNull((e) => e.id == list[i].userId!) ==
                null
            ? FutureBuilder(
                future: controller.getInteractionUser(list[i].userId!),
                builder: (context, snapshot) {
                  MyUserModel? interactionUser = controller.interactionUsers
                      .firstWhereOrNull((e) => e.id == list[i].userId!);
                  interactionUser ??= MyUserModel(id: list[i].userId);
                  return _interactionTile(type, interactionUser, list[i]);
                },
              )
            : _interactionTile(
                type,
                controller.interactionUsers
                    .firstWhere((e) => e.id == list[i].userId!),
                list[i]),
      );

  Widget _interactionTile(MyInteractionType type, MyUserModel interactionUser,
          MyInteractionModel interactionModel) =>
      type == MyInteractionType.comment
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _profile(interactionUser.profilePicUrl,
                    interactionModel.userId != controller.currentUser.id),
                _comment(interactionUser, interactionModel.data ?? 'Null'),
                _profile(interactionUser.profilePicUrl,
                    interactionModel.userId == controller.currentUser.id),
              ],
            )
          : Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                  color: MyColorHelper.white.withOpacity(0.85),
                  border:
                      Border.all(color: MyColorHelper.red1.withOpacity(0.15)),
                  borderRadius: BorderRadius.circular(8.0)),
              child: ListTile(
                dense: true,
                leading: _profile(interactionUser.profilePicUrl, true),
                title: Text(
                  interactionUser.fullName ?? 'Null',
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  interactionUser.email ?? 'Null',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );

  Widget _profile(String? url, bool show) => Opacity(
        opacity: show ? 1.0 : 0.0,
        child: CircleAvatar(
          radius: 20,
          backgroundColor: MyColorHelper.red1.withOpacity(0.05),
          backgroundImage: url == null
              ? const AssetImage('assets/images/default-profile.png')
              : null,
          foregroundImage: url != null ? NetworkImage(url) : null,
        ),
      );

  Widget _comment(MyUserModel model, String comment) => Expanded(
        child: Container(
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
              color: model.id == controller.currentUser.id
                  ? MyColorHelper.white.withOpacity(0.85)
                  : MyColorHelper.red1.withOpacity(0.05),
              border: Border.all(color: MyColorHelper.red1.withOpacity(0.15)),
              borderRadius: BorderRadius.only(
                  topLeft: model.id == controller.currentUser.id
                      ? const Radius.circular(8.0)
                      : Radius.zero,
                  topRight: model.id != controller.currentUser.id
                      ? const Radius.circular(8.0)
                      : Radius.zero,
                  bottomLeft: const Radius.circular(8.0),
                  bottomRight: const Radius.circular(8.0))),
          child: ListTile(
            dense: true,
            title: Text(
              model.fullName ?? 'Null',
              textAlign: model.id == controller.currentUser.id
                  ? TextAlign.right
                  : TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              textAlign: model.id == controller.currentUser.id
                  ? TextAlign.right
                  : TextAlign.left,
              comment,
            ),
          ),
        ),
      );
}
