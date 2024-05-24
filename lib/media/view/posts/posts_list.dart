part of 'page.dart';

class _MyPostsList extends StatelessWidget {
  _MyPostsList();
  final MyPostsController controller = Get.find<MyPostsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.separated(
        padding: const EdgeInsets.all(12.0),
        itemCount: controller.posts.length,
        itemBuilder: (context, i) {
          return OpenContainer(
            closedElevation: 4.0,
            closedBuilder: (context, action) => InkWell(
              onTap: action,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 16.0),
                child: Column(
                  children: [
                    _PostedBy(controller.posts[i]),
                    const SizedBox(height: 8.0),
                    _PostMedia(controller.posts[i]),
                    const SizedBox(height: 12.0),
                    _PostDetail(i),
                    const SizedBox(height: 8.0),
                    const Divider(),
                    _MyInteractions(i)
                  ],
                ),
              ),
            ),
            openBuilder: (context, action) => _OpenPostDetail(i),
          );
        },
        separatorBuilder: (context, i) => const Divider(height: 48.0),
      ),
    );
  }
}
