import 'package:animations/animations.dart';
import 'package:app/helper/buttons/buttons.dart';
import 'package:app/helper/colors.dart';
import 'package:app/helper/snackbars.dart';
import 'package:app/media/controller/followings_controller.dart';
import 'package:app/media/controller/universal_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

part 'detail.dart';
part 'tile.dart';

class MyFollowingsPage extends StatefulWidget {
  const MyFollowingsPage({super.key});

  @override
  State<MyFollowingsPage> createState() => _MyFollowingsPageState();
}

class _MyFollowingsPageState extends State<MyFollowingsPage> {
  final controller = Get.put(MyFollowingsController(
      Get.find<MyMediaUniversalController>().currentUser));

  @override
  void dispose() {
    Get.delete<MyFollowingsController>();
    super.dispose();
  }

  // @override
  // void initState() {
  //   controller.loadFollowings();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: (controller.loading)
            ? const [
                Center(
                    child: CircularProgressIndicator(
                  color: MyColorHelper.red1,
                ))
              ]
            : (controller.error != null)
                ? [
                    Center(
                        child: Text(controller.error!,
                            overflow: TextOverflow.ellipsis))
                  ]
                : (controller.followings.isEmpty)
                    ? [
                        const Center(
                            child: Text('You are not following any one.',
                                overflow: TextOverflow.ellipsis))
                      ]
                    : [
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.all(8.0),
                            itemCount: controller.followings.length,
                            itemBuilder: (context, i) {
                              return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: _MyTile(i, controller));
                            },
                            separatorBuilder: (context, i) => const Divider(),
                          ),
                        )
                      ],
      ),
    );
  }
}
