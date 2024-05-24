import 'package:animations/animations.dart';
import 'package:app/essentials/delete_account.dart';
import 'package:app/essentials/privacy_policy.dart';
import 'package:app/helper/buttons/buttons.dart';
import 'package:app/helper/colors.dart';
import 'package:app/helper/designs.dart';
import 'package:app/helper/dialog.dart';
import 'package:app/helper/responsive.dart';
import 'package:app/helper/snackbars.dart';
import 'package:app/media/controller/universal_controller.dart';
import 'package:app/media/view/auth/screen.dart';
import 'package:app/media/view/companies/screen.dart';
import 'package:app/media/view/followings/screen.dart';
import 'package:app/media/view/posts/page.dart';
import 'package:app/media/view/user_support/page.dart';
import 'package:app/model/dashboard_model.dart';
import 'package:app/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sidebarx/sidebarx.dart';

part 'notification.dart';
part 'profile.dart';
part 'side_bar.dart';

class MyMediaDashboardScreen extends StatefulWidget {
  const MyMediaDashboardScreen({super.key, required this.currentUser});
  final MyUserModel currentUser;

  @override
  State<MyMediaDashboardScreen> createState() => _MyMediaDashboardScreenState();
}

class _MyMediaDashboardScreenState extends State<MyMediaDashboardScreen> {
  late MyMediaUniversalController mediaUniversalController;
  late GlobalKey<ScaffoldState> _key;
  late List<MyDashboardModel> _data;
  late SidebarXController _sideBarController;
  @override
  void initState() {
    listenNotification();
    mediaUniversalController =
        Get.put(MyMediaUniversalController(widget.currentUser));
    _key = GlobalKey<ScaffoldState>();
    _data = [
      MyDashboardModel(
        icon: Icons.dashboard_rounded,
        title: 'News Feed',
        widget: MyPostsPage(),
      ),
      MyDashboardModel(
        icon: Icons.apartment_rounded,
        title: 'PR Companies',
        widget: const MyCompaniesPage(),
      ),
      MyDashboardModel(
        icon: Icons.person_add_rounded,
        title: 'Following',
        widget: const MyFollowingsPage(),
      ),
      MyDashboardModel(
        icon: Icons.privacy_tip_outlined,
        title: 'Privacy Policy',
        widget: MyPrivacyPolicy(dashboard: true),
      ),
      MyDashboardModel(
        icon: Icons.contact_support_rounded,
        title: 'Contact RTSC',
        widget: MyUserSupportPage(currentUser: widget.currentUser),
      ),
    ];
    _sideBarController = SidebarXController(
        selectedIndex: mediaUniversalController.tabIndex, extended: true);
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<MyMediaUniversalController>();
    super.dispose();
  }

  void onChangeTab(int i) {
    mediaUniversalController.setTabIndex = i;
    _key.currentState?.closeDrawer();
  }

  @override
  Widget build(BuildContext context) {
    bool style = (context.width < myDefaultMaxWidth || !context.isLandscape);
    return Obx(
      () => PopScope(
        canPop: mediaUniversalController.tabIndex == 0,
        onPopInvoked: (value) {
          print(mediaUniversalController.tabIndex);
          if (mediaUniversalController.tabIndex != 0) {
            mediaUniversalController.setTabIndex = 0;
          }
        },
        child: SafeArea(
          child: Scaffold(
            key: _key,
            backgroundColor: MyColorHelper.white,
            drawer: style
                ? _MySideBar(_sideBarController, _data, onChangeTab)
                : null,
            body: Row(
              children: [
                if (context.width >= myDefaultMaxWidth && context.isLandscape)
                  _MySideBar(_sideBarController, _data, onChangeTab),
                Expanded(
                  child: Column(
                    children: [
                      AppBar(
                        toolbarHeight: kToolbarHeight * 1.25,
                        backgroundColor: MyColorHelper.red1,
                        title: Text(
                            _data[_sideBarController.selectedIndex].title,
                            style: const TextStyle(color: MyColorHelper.white)),
                        leading: style
                            ? IconButton(
                                onPressed: () =>
                                    _key.currentState?.openDrawer(),
                                icon: const Icon(Icons.menu,
                                    color: MyColorHelper.white),
                              )
                            : null,
                        actions: [
                          OpenContainer(
                            closedColor: Colors.transparent,
                            closedShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0)),
                            closedElevation: 0,
                            closedBuilder: (cContext, action) => CircleAvatar(
                              radius: mediaUniversalController.profileUpdated
                                  ? 25
                                  : 25,
                              backgroundImage: mediaUniversalController
                                          .currentUser.profilePicUrl ==
                                      null
                                  ? const AssetImage(
                                      'assets/images/default-profile.png',
                                    )
                                  : null,
                              foregroundImage: mediaUniversalController
                                          .currentUser.profilePicUrl !=
                                      null
                                  ? NetworkImage(mediaUniversalController
                                      .currentUser.profilePicUrl!)
                                  : null,
                            ),
                            openBuilder: (BuildContext context,
                                    void Function({Object? returnValue})
                                        action) =>
                                const _MyProfilePage(),
                          ),
                          const SizedBox(width: 16.0),
                        ],
                      ),
                      // _MyTopBar(),
                      Expanded(
                        child: ColoredBox(
                          color: MyColorHelper.white,
                          child:
                              _data[mediaUniversalController.tabIndex].widget,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
