part of 'page.dart';

class _MyPostsList extends StatelessWidget {
  const _MyPostsList(this.controller, this.likes, this.comments, this.shares);
  final MyPostsController controller;
  final List<MyInteractionModel> likes, comments, shares;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.separated(
        controller: controller.scrollController,
        padding: const EdgeInsets.all(12.0),
        itemCount: controller.posts.length,
        itemBuilder: (context, i) {
          return LayoutBuilder(
            builder: (context, constraints) => InkWell(
              onTap: () {
                controller.initialInteraction = 0;
                controller.setSelectedPost(controller.posts[i]);
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 21,
                            backgroundColor:
                                MyColorHelper.red1.withOpacity(0.50),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  controller.posts[i].userProfilePicUrl == null
                                      ? const AssetImage(
                                          'assets/images/default-profile.png',
                                        )
                                      : null,
                              foregroundImage:
                                  controller.posts[i].userProfilePicUrl != null
                                      ? NetworkImage(
                                          controller
                                              .posts[i].userProfilePicUrl!,
                                        )
                                      : null,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${controller.posts[i].userName ?? 'Null'} '
                                  '(${controller.posts[i].userType == 'admin' ? 'Admin'
                                      '' : controller.posts[i].userType == 'user' ? 'Manager'
                                      '' : controller.posts[i].userType == 'prMember' ? 'PR Member'
                                      '' : 'Null'})',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                                const SizedBox(width: 4.0),
                                Text(
                                  'Email: ${controller.posts[i].userEmail ?? 'Not Attached'}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color:
                                        MyColorHelper.black.withOpacity(0.50),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                DateFormat('MM-dd-yyyy')
                                    .format(controller.posts[i].createdAt!),
                                style: TextStyle(color: Colors.black54),
                              ),
                              Text(
                                DateFormat('hh:mm a')
                                    .format(controller.posts[i].createdAt!),
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 12.0),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: Container(
                          color: MyColorHelper.red1.withOpacity(0.70),
                          child: constraints.maxWidth > myDefaultMaxWidth
                              ? SizedBox(
                                  height: constraints.maxWidth * 0.30,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _MyImage(model: controller.posts[i]),
                                      Expanded(
                                          child: _MyDetail(
                                        model: controller.posts[i],
                                        height: constraints.maxWidth * 0.30,
                                      )),
                                    ],
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        width: constraints.maxWidth,
                                        child: _MyImage(
                                            model: controller.posts[i])),
                                    _MyDetail(
                                      model: controller.posts[i],
                                      height: constraints.maxWidth * 0.50,
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      Divider(color: MyColorHelper.red1.withOpacity(0.25)),
                      _MyInteractions(
                        controller,
                        i,
                        likes: likes
                            .where((e) => e.postId == controller.posts[i].id)
                            .toList(),
                        comments: comments
                            .where((e) => e.postId == controller.posts[i].id)
                            .toList(),
                        shares: shares
                            .where((e) => e.postId == controller.posts[i].id)
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, i) => const Divider(height: 32.0),
      ),
    );
  }
}
