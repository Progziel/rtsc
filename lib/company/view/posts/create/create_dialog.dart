part of '../page.dart';

void showAddPostDialog(BuildContext context) async {
  final controller = Get.find<MyPostsController>();
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const _MyAlertDialog(),
  ).then((value) {
    if (controller.selectedPost == null) {
      controller.clearAll();
    }
  });
}

class _MyAlertDialog extends StatefulWidget {
  const _MyAlertDialog();

  @override
  State<_MyAlertDialog> createState() => _MyAlertDialogState();
}

class _MyAlertDialogState extends State<_MyAlertDialog> {
  final _controller = Get.find<MyPostsController>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      content: SizedBox(
        width: context.isLandscape ? context.width * 0.75 : context.width,
        height: context.height > myResponsiveHeight
            ? context.height * 0.75
            : myResponsiveHeight,
        child: DefaultTabController(
          length: 4,
          child: LayoutBuilder(
            builder: (context, constraints) => constraints.maxWidth > 700
                ? Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _title('Create'),
                            Expanded(
                                child: _CreateSection(_controller,
                                    landscape: true)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24.0),
                      Expanded(flex: 2, child: _PreviewSection(_controller)),
                    ],
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _title('Create'),
                        _CreateSection(_controller, landscape: false),
                        const SizedBox(height: 16.0),
                        SizedBox(
                          height: constraints.maxWidth * 0.90,
                          child: _PreviewSection(_controller, scrollable: true),
                        )
                      ],
                    ),
                  ),
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _controller.loadingDialog
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: MyColorHelper.red1,
                    ))
                  : Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            hoverColor: Colors.transparent,
                            onTap: () {
                              _controller.clearAll();
                              Get.back();
                            },
                            child: const Text('Cancel'),
                          ),
                          if (_controller.selectedPost == null)
                            InkWell(
                              hoverColor: Colors.transparent,
                              onTap: () async {
                                String? error = await _controller
                                    .createUpdateOrDraftPost(draft: true);
                                (error == null)
                                    ? Get.back()
                                    : MySnackBarsHelper.showError(error);
                              },
                              child: const Text('Save as Draft'),
                            ),
                          InkWell(
                            hoverColor: Colors.transparent,
                            onTap: () async {
                              String? error =
                                  await _controller.createUpdateOrDraftPost();
                              (error == null)
                                  ? Get.back()
                                  : MySnackBarsHelper.showError(error);
                            },
                            child: Text(_controller.selectedPost == null
                                ? 'Post'
                                : 'Update'),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        )
      ],
    );
  }
}

BoxDecoration _boxDecoration() => BoxDecoration(
    color: MyColorHelper.black.withOpacity(0.05),
    border: Border.all(color: MyColorHelper.black.withOpacity(0.10)),
    borderRadius: const BorderRadius.all(Radius.circular(16.0)));

Widget _title(String title) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(title,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: MyColorHelper.black.withOpacity(0.60))),
    );
