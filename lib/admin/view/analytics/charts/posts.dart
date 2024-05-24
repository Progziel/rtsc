part of '../page.dart';

class _MyLatestPosts extends StatelessWidget {
  const _MyLatestPosts(this.controller);
  final MyAnalyticsController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: controller.postsAnalytics.length,
          itemBuilder: (context, i) {
            return Container(
              margin: const EdgeInsets.all(8.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                  border:
                      Border.all(color: MyColorHelper.red1.withOpacity(0.10)),
                  color: MyColorHelper.red1.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(32.0)),
              child: ListTile(
                dense: true,
                onTap: () => showDialog(
                    context: context,
                    builder: (context) =>
                        MyPostDetailDialog(controller.postsAnalytics[i])),
                contentPadding: const EdgeInsets.all(8.0),
                shape: InputBorder.none,
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: MyColorHelper.red1.withOpacity(0.08),
                    ),
                    color: MyColorHelper.red1.withOpacity(0.05),
                    image: controller.postsAnalytics[i].userProfilePicUrl !=
                            null
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              controller.postsAnalytics[i].userProfilePicUrl!,
                            ))
                        : const DecorationImage(
                            image: AssetImage(
                            'assets/images/default-profile.png',
                          )),
                  ),
                ),
                title: Text(
                    'Posted By: ${controller.postsAnalytics[i].userName ?? 'Null'} '
                    '(${controller.postsAnalytics[i].userType == 'admin' ? 'Admin'
                        '' : controller.postsAnalytics[i].userType == 'user' ? 'Manager'
                        '' : controller.postsAnalytics[i].userType == 'prMember' ? 'PR Member'
                        '' : 'Null'})',
                    overflow: TextOverflow.ellipsis),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Company: ${controller.postsAnalytics[i].companyName ?? 'Null'}',
                      overflow: TextOverflow.ellipsis,
                    ),
                    (controller.postsAnalytics[i].titleJson != null)
                        ? SizedBox(
                            height: 18,
                            child: Row(
                              children: [
                                Expanded(
                                  child: MyQuillEditor(
                                      controller: QuillController.basic()
                                        ..setContents(Delta.fromJson(controller
                                            .postsAnalytics[i].titleJson!)),
                                      readOnly: true,
                                      textStyles: const DefaultStyles(
                                        paragraph: DefaultTextBlockStyle(
                                          TextStyle(
                                              fontSize: 13,
                                              color: Colors.black54),
                                          VerticalSpacing(4.0, 0),
                                          VerticalSpacing(0, 0),
                                          null,
                                        ),
                                      )),
                                ),
                                const Text('...'),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(DateFormat('MM-dd-yyyy')
                        .format(controller.postsAnalytics[i].createdAt!)),
                    Text(
                      DateFormat('hh:mm a')
                          .format(controller.postsAnalytics[i].createdAt!),
                      style: const TextStyle(fontSize: 10.0),
                    ),
                  ],
                ),
              ),
            );
          },
          // separatorBuilder: (context, i) => const Divider(),
        ),
      ),
    );
  }
}
