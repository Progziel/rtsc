part of 'screen.dart';

class _MyFollowingDetail extends StatelessWidget {
  const _MyFollowingDetail(this.i, this.controller);
  final int i;
  final MyFollowingsController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColorHelper.black.withOpacity(0.10),
        appBar: AppBar(
          title: Text(controller.followings[i].companyName ?? 'Null'),
          foregroundColor: MyColorHelper.white.withOpacity(0.75),
          backgroundColor: MyColorHelper.black1,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 200,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 16.0),
                decoration: const BoxDecoration(
                    color: MyColorHelper.black1,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Text(
                        controller.followings[i].description ?? 'Null',
                        maxLines: 4,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: MyColorHelper.white.withOpacity(0.75),
                        ),
                      ),
                    ),
                    SizedBox(width: 4.0),
                    Expanded(
                      flex: 2,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: MyColorHelper.red1.withOpacity(0.08),
                            ),
                            color: MyColorHelper.red1.withOpacity(0.05),
                            image: controller.followings[i].logoUrl != null
                                ? DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        controller.followings[i].logoUrl!),
                                  )
                                : const DecorationImage(
                                    image: AssetImage(
                                    'assets/images/default-company-logo.png',
                                  )),
                          ),
                        ),
                      ),
                    )
                    // Expanded(
                    //     flex: 2,
                    //     child: controller.followings[i].logoUrl != null
                    //         ? Image.network(controller.followings[i].logoUrl!)
                    //         : Image.asset(
                    //             'assets/images/default-company-logo.png',
                    //           ))
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, top: 24.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _detail(
                        'Owner\'s Name', controller.followings[i].ownerName),
                    // _detail('Mailing Address',
                    //     controller.followings[i].mailingAddress),
                    // _detail('Phone', controller.followings[i].phone),
                    _detail('Email', controller.followings[i].email),
                    const SizedBox(height: 16),
                    MyButtonHelper.simpleButton(
                      buttonText: 'Unfollow',
                      textColor: MyColorHelper.black1,
                      buttonColor: Colors.white.withOpacity(0.75),
                      onTap: () {
                        Get.back();
                        _confirmation(
                            context, controller.followings[i].companyName);
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
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

  void _confirmation(BuildContext context, String? companyName) {
    final loading = false.obs;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (bContext) => Obx(() => AlertDialog(
              title: const Text('Confirmation', textAlign: TextAlign.center),
              content: Column(
                children: [
                  Text('Are you sure to unfollow \'$companyName\'?'),
                  const SizedBox(height: 24.0),
                ],
              ),
              scrollable: true,
              actionsAlignment: loading.value
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceBetween,
              actions: loading.value
                  ? [const CircularProgressIndicator(color: MyColorHelper.red1)]
                  : [
                      InkWell(
                        onTap: () => Get.back(),
                        child: const Text('No'),
                      ),
                      InkWell(
                        onTap: () async {
                          loading.value = true;
                          await controller.onUnfollow(
                              controller.followings[i], controller.currentUser);
                          Get.back();
                          // Get.back();
                          // await Future.delayed(1.seconds);
                          // controller.followings
                          //     .remove(controller.followings[i]);
                        },
                        child: const Text('Yes'),
                      ),
                    ],
            )));
  }
}
