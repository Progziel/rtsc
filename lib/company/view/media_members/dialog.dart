part of 'page.dart';

class _MyDialog extends StatefulWidget {
  const _MyDialog(this.model, this.controller);
  final MyUserModel model;
  final MyMediaMembersController controller;

  @override
  State<_MyDialog> createState() => _MyDialogState();
}

class _MyDialogState extends State<_MyDialog> {
  final _loading = false.obs;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AlertDialog(
        scrollable: true,
        icon: Image.asset(
          width: 400,
          height: 100,
          'assets/images/default-profile.png',
        ),
        title: Text(widget.model.fullName ?? 'Null'),
        content: Column(
          children: [
            _detail('Phone', widget.model.phone),
            _detail('Email', widget.model.email),
            _detail('Media Outlet Name', widget.model.mediaOutletName),
            const SizedBox(height: 24.0),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          _loading.value
              ? const CircularProgressIndicator(
                  color: MyColorHelper.red1,
                )
              : _error != null
                  ? Text(_error!, style: const TextStyle(color: Colors.red))
                  : Row(
                      children: (widget.controller.followers
                              .any((element) => element.id == widget.model.id))
                          ? [
                              Expanded(
                                child: MyButtonHelper.simpleButton(
                                  buttonColor: Colors.red,
                                  borderColor: Colors.red,
                                  buttonText: 'Unfollow',
                                  padding: 8.0,
                                  onTap: () async {
                                    Get.back();
                                    MyDialogHelper.showLoadingDialog(context,
                                        dark: true);
                                    String? response = await widget.controller
                                        .onUnFollow(widget.model);
                                    Get.back();
                                    if (response != null) {
                                      MySnackBarsHelper.showError(response);
                                    }
                                  },
                                ),
                              )
                            ]
                          : [
                              Expanded(
                                child: MyButtonHelper.simpleButton(
                                  buttonColor: Colors.green,
                                  borderColor: Colors.green,
                                  buttonText: 'Accept',
                                  padding: 8.0,
                                  onTap: () async {
                                    Get.back();
                                    MyDialogHelper.showLoadingDialog(context,
                                        dark: true);
                                    String? response = await widget.controller
                                        .onAccept(widget.model);
                                    Get.back();
                                    if (response != null) {
                                      MySnackBarsHelper.showError(response);
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                child: MyButtonHelper.simpleButton(
                                  buttonColor: Colors.red,
                                  borderColor: Colors.red,
                                  buttonText: 'Reject',
                                  padding: 8.0,
                                  onTap: () async {
                                    Get.back();
                                    MyDialogHelper.showLoadingDialog(context,
                                        dark: true);
                                    String? response = await widget.controller
                                        .onReject(widget.model);
                                    Get.back();
                                    if (response != null) {
                                      MySnackBarsHelper.showError(response);
                                    }
                                  },
                                ),
                              ),
                            ],
                    )
        ],
      ),
    );
  }

  Widget _detail(String str1, String? str2) => Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Expanded(
                child: Text('$str1: ',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ))),
            Text(
              str2 ?? 'Null',
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
}
