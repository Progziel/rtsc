part of 'page.dart';

class _MyDraftPostsList extends StatelessWidget {
  const _MyDraftPostsList({required this.controller});
  final MyDraftPostsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.separated(
        padding: const EdgeInsets.all(12.0),
        itemCount: controller.posts.length,
        itemBuilder: (context, i) {
          return LayoutBuilder(
            builder: (context, constraints) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 2.0, bottom: 2.0),
                  child: Row(
                    children: [
                      CircleAvatar(
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
                                    controller.posts[i].userProfilePicUrl!,
                                  )
                                : null,
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
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              '(${controller.posts[i].companyName})',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: MyColorHelper.black.withOpacity(0.50),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(DateFormat('MM-dd-yyyy')
                              .format(controller.posts[i].createdAt!)),
                          Text(
                            DateFormat('hh:mm a')
                                .format(controller.posts[i].createdAt!),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: MyColorHelper.red1.withOpacity(0.50),
                          width: 2),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8.0),
                      )),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          controller.setDraftPost = i;
                          return _MyAlertDialog(controller);
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: MyColorHelper.red1.withOpacity(0.75),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: constraints.maxWidth > myDefaultMaxWidth
                          ? SizedBox(
                              height: constraints.maxWidth * 0.30,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    child:
                                        _MyImage(model: controller.posts[i])),
                                _MyDetail(
                                  model: controller.posts[i],
                                  height: constraints.maxWidth * 0.50,
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, i) => const Divider(height: 32.0),
      ),
    );
  }
}
