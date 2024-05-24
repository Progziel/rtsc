part of '../page.dart';

class _MyAlertDialog extends StatelessWidget {
  const _MyAlertDialog(this.controller);
  final MyDraftPostsController controller;

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
                                child: _CreateSection(controller,
                                    landscape: true)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24.0),
                      Expanded(
                          flex: 2,
                          child: _PreviewSection(
                            controller,
                            onDelete: () => _onDelete(context),
                          )),
                    ],
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: _title('Create')),
                            IconButton(
                                onPressed: () => _onDelete(context),
                                icon: const Icon(
                                  Icons.delete_rounded,
                                ))
                          ],
                        ),
                        _CreateSection(controller, landscape: false),
                        const SizedBox(height: 16.0),
                        SizedBox(
                          height: constraints.maxWidth * 0.90,
                          child: _PreviewSection(controller, scrollable: true),
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
              controller.loadingDialog
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
                            onTap: () => Get.back(),
                            child: const Text('Cancel'),
                          ),
                          InkWell(
                            hoverColor: Colors.transparent,
                            onTap: () async {
                              await controller.onPost(post: false);
                              Get.back();
                            },
                            child: const Text('Save'),
                          ),
                          InkWell(
                            hoverColor: Colors.transparent,
                            onTap: () async {
                              await controller.onPost();
                              Get.back();
                            },
                            child: const Text('Post'),
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

  void _onDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Confirmation'),
        scrollable: true,
        content: const Text('Are you sure to delete this post?'),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          MyButtonHelper.simpleButton(
            buttonText: 'Delete',
            buttonColor: Colors.red,
            onTap: () async {
              Get.back();
              await controller.onDeletePost();
              Get.back();
            },
          )
        ],
      ),
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
          textAlign: TextAlign.start,
          style: TextStyle(
              fontSize: 20, color: MyColorHelper.black.withOpacity(0.60))),
    );
