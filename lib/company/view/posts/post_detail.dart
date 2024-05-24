part of 'page.dart';

class _MyPostDetail extends StatelessWidget {
  const _MyPostDetail(this.controller, this.likes, this.comments, this.shares);
  final MyPostsController controller;
  final List<MyInteractionModel> likes, comments, shares;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: MyColorHelper.red1.withOpacity(0.70),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    tooltip: 'Close',
                    onPressed: () => controller.setSelectedPost(null),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: MyColorHelper.white,
                    )),
                Obx(() => Text(
                    (constraints.maxWidth < myDefaultMaxWidth &&
                            !controller.landscapeMode.value)
                        ? 'Comments'
                        : 'Detail',
                    style: TextStyle(
                      color: MyColorHelper.white,
                      fontSize: controller.landscapeMode.value ? 16 : 16,
                    ))),
                IconButton(
                    tooltip: 'Delete',
                    onPressed: () => _onDelete(context),
                    icon: const Icon(
                      Icons.delete_rounded,
                      color: MyColorHelper.white,
                    )),
              ],
            ),
          ),
          constraints.maxWidth > myDefaultMaxWidth
              ? Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 2,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: _detail(),
                          )),
                      _interactions()
                    ],
                  ),
                )
              : Obx(() => controller.landscapeMode.value
                  ? Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            _detail(),
                            Divider(
                                color: MyColorHelper.red1.withOpacity(0.75)),
                            _MyInteractions(
                              controller,
                              controller.posts
                                  .indexOf(controller.selectedPost!),
                              landscape: false,
                              likes: likes,
                              comments: comments,
                              shares: shares,
                            ),
                          ],
                        ),
                      ),
                    )
                  : _interactions()),
        ],
      ),
    );
  }

  void _onDelete(BuildContext context) {
    final loading = false.obs;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Confirmation'),
              content: const Text('Are you sure to delete this post?'),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                Obx(
                  () => loading.value
                      ? const CircularProgressIndicator(
                          color: MyColorHelper.red1,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              hoverColor: Colors.transparent,
                              onTap: () => Get.back(),
                              child: const Text('Cancel'),
                            ),
                            InkWell(
                              hoverColor: Colors.transparent,
                              onTap: () async {
                                loading.value = true;
                                String? response =
                                    await controller.deletePost();
                                loading.value = false;
                                (response == null)
                                    ? Get.back()
                                    : MySnackBarsHelper.showError(response);
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                )
              ],
            ));
  }

  Widget _detail() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: controller.selectedPost!.imageUrl != null
                  ? Image.network(
                      fit: BoxFit.cover,
                      controller.selectedPost!.imageUrl!,
                    )
                  : controller.selectedPost!.videoUrl != null
                      ? MyPlayer(path: controller.selectedPost!.videoUrl!)
                      : controller.selectedPost!.audioUrl != null
                          ? MyPlayer(
                              path: controller.selectedPost!.audioUrl!,
                              audio: true)
                          : controller.selectedPost!.documentUrl != null
                              ? SfPdfViewer.network(
                                  controller.selectedPost!.documentUrl!,
                                )
                              : Image.asset('assets/images/default-image.png',
                                  fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: LayoutBuilder(
              builder: (context, constraints) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyQuillEditor(
                    controller: QuillController.basic()
                      ..setContents(
                          Delta.fromJson(controller.selectedPost!.titleJson!)),
                    readOnly: true,
                  ),
                  const SizedBox(height: 8.0),
                  MyQuillEditor(
                    controller: QuillController.basic()
                      ..setContents(Delta.fromJson(
                          controller.selectedPost!.subtitleJson!)),
                    readOnly: true,
                  ),
                  const Divider(),
                  if (controller.selectedPost!.descriptionJson != null)
                    ..._description(constraints)
                ],
              ),
            ),
          ),
        ],
      );

  List<Widget> _description(BoxConstraints constraints) {
    List<Widget> description = [];
    final RegExp pattern =
        RegExp(r'https://www\.youtube\.com/watch\?v=([a-zA-Z0-9_-]+)');
    List<dynamic> part = [];
    List<Widget> widgets = [];
    for (final element in controller.selectedPost!.descriptionJson!) {
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
            width: constraints.maxWidth * 0.75,
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

  Widget _interactions() => Expanded(
        child: Container(
          margin: const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 8.0),
          decoration: BoxDecoration(
              color: MyColorHelper.black.withOpacity(0.05),
              border: Border.all(color: MyColorHelper.black.withOpacity(0.10)),
              borderRadius: const BorderRadius.all(Radius.circular(16.0))),
          child: DefaultTabController(
            initialIndex: controller.initialInteraction,
            length: 3,
            child: Column(
              children: [
                TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: MyColorHelper.black.withOpacity(0.10),
                  tabs: [
                    Tab(
                        icon: const Icon(Icons.thumb_up_outlined),
                        text:
                            likes.isNotEmpty ? likes.length.toString() : null),
                    Tab(
                        icon: const Icon(Icons.comment_outlined),
                        text: comments.isNotEmpty
                            ? comments.length.toString()
                            : null),
                    Tab(
                        icon: const Icon(Icons.share_outlined),
                        text: shares.isNotEmpty
                            ? shares.length.toString()
                            : null),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      likes.isEmpty
                          ? _notFound('likes')
                          : _likesOrShares(likes),
                      _comments(comments),
                      shares.isEmpty
                          ? _notFound('shares')
                          : _likesOrShares(shares),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _notFound(String string) => Center(child: Text('No $string found!'));

  Widget _likesOrShares(List<MyInteractionModel> list) => ListView.builder(
        padding: const EdgeInsets.all(4.0),
        itemCount: list.length,
        itemBuilder: (context, i) => Container(
          margin: const EdgeInsets.all(4.0),
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
              color: MyColorHelper.white.withOpacity(0.25),
              border: Border.all(color: MyColorHelper.red1.withOpacity(0.10)),
              borderRadius: BorderRadius.circular(8.0)),
          child: FutureBuilder(
            future: controller.getInteractionUser(list[i].userId!),
            builder: (context, snapshot) {
              MyUserModel interactionUser = MyUserModel(id: list[i].userId);
              if (snapshot.hasData && snapshot.data != null) {
                interactionUser = MyUserModel.fromMap(
                    snapshot.data!.data() as Map<String, dynamic>);
              }
              return ListTile(
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
              );
            },
          ),
        ),
      );

  Widget _comments(List<MyInteractionModel> list) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Expanded(
              child: list.isEmpty
                  ? _notFound('comments')
                  : ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.all(4.0),
                      itemCount: list.length,
                      itemBuilder: (context, i) => FutureBuilder(
                          future:
                              controller.getInteractionUser(list[i].userId!),
                          builder: (context, snapshot) {
                            MyUserModel interactionUser =
                                MyUserModel(id: list[i].userId);
                            if (snapshot.hasData && snapshot.data != null) {
                              interactionUser = MyUserModel.fromMap(
                                  snapshot.data!.data()
                                      as Map<String, dynamic>);
                            }
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _profile(
                                    interactionUser.profilePicUrl,
                                    list[i].userId !=
                                        companyUniversalController
                                            .currentUser.id),
                                _comment(
                                    interactionUser, list[i].data ?? 'Null'),
                                _profile(
                                    interactionUser.profilePicUrl,
                                    list[i].userId ==
                                        companyUniversalController
                                            .currentUser.id),
                              ],
                            );
                          }),
                    ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextFormField(
                      controller: controller.comments,
                      decoration: MyDecorationHelper.textFieldDecoration(
                          hints: 'Comment here...',
                          borderColor: MyColorHelper.black.withOpacity(0.50)),
                      onFieldSubmitted: (value) => controller.onComments(
                          controller.posts.indexOf(controller.selectedPost!)),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () => controller.onComments(
                        controller.posts.indexOf(controller.selectedPost!)),
                    icon: Icon(
                      Icons.send,
                      color: MyColorHelper.black.withOpacity(0.50),
                    ))
              ],
            ),
          ],
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
              color: MyColorHelper.white.withOpacity(0.25),
              border: Border.all(color: MyColorHelper.red1.withOpacity(0.10)),
              borderRadius: BorderRadius.only(
                  topLeft: model.id == companyUniversalController.currentUser.id
                      ? const Radius.circular(8.0)
                      : Radius.zero,
                  topRight:
                      model.id != companyUniversalController.currentUser.id
                          ? const Radius.circular(8.0)
                          : Radius.zero,
                  bottomLeft: const Radius.circular(8.0),
                  bottomRight: const Radius.circular(8.0))),
          child: ListTile(
            dense: true,
            title: Text(
              model.fullName ?? 'Null',
              textAlign: model.id == companyUniversalController.currentUser.id
                  ? TextAlign.right
                  : TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              textAlign: model.id == companyUniversalController.currentUser.id
                  ? TextAlign.right
                  : TextAlign.left,
              comment,
            ),
          ),
        ),
      );
}
