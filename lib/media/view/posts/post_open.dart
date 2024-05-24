part of 'page.dart';

class _OpenPostDetail extends StatelessWidget {
  _OpenPostDetail(this.i);
  final int i;
  final MyPostsController controller = Get.find<MyPostsController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Post Detail'),
          foregroundColor: MyColorHelper.white,
          backgroundColor: MyColorHelper.red1,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _PostedBy(controller.posts[i]),
                      const SizedBox(height: 8.0),
                      _PostMedia(controller.posts[i], short: false),
                      const SizedBox(height: 12.0),
                      _PostDetail(i, short: false),
                      const SizedBox(height: 8.0),
                    ],
                  ),
                ),
              ),
              const Divider(),
              _MyInteractions(i)
            ],
          ),
        ),
      ),
    );
  }
}
