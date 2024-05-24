import 'package:app/company/controller/companyUniversal_controller.dart';
import 'package:app/company/view/analytics/page.dart';
import 'package:app/company/view/drafts/page.dart';
import 'package:app/company/view/media_members/page.dart';
import 'package:app/company/view/posts/page.dart';
import 'package:app/company/view/users/page.dart';
import 'package:app/essentials/privacy_policy.dart';
import 'package:app/helper/buttons/buttons.dart';
import 'package:app/helper/colors.dart';
import 'package:app/helper/designs.dart';
import 'package:app/helper/image_picker.dart';
import 'package:app/helper/responsive.dart';
import 'package:app/helper/snackbars.dart';
import 'package:app/model/company_model.dart';
import 'package:app/model/dashboard_model.dart';
import 'package:app/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sidebarx/sidebarx.dart';

part 'profile.dart';
part 'side_bar.dart';

late MyCompanyUniversalController companyUniversalController;

class MyCompanyDashboardScreen extends StatefulWidget {
  const MyCompanyDashboardScreen({
    super.key,
    required this.currentUser,
    required this.currentCompany,
  });

  final MyUserModel currentUser;
  final MyCompanyModel currentCompany;

  @override
  State<MyCompanyDashboardScreen> createState() =>
      _MyCompanyDashboardScreenState();
}

class _MyCompanyDashboardScreenState extends State<MyCompanyDashboardScreen> {
  late List<MyDashboardModel> _data;
  @override
  void initState() {
    companyUniversalController =
        MyCompanyUniversalController(widget.currentCompany, widget.currentUser);
    companyUniversalController.setTabIndex = 0;
    _data = [
      if (widget.currentUser.userType != MyUserType.prMember) ...[
        MyDashboardModel(
          icon: Icons.dashboard_rounded,
          title: 'Analytics',
          widget: const MyAnalyticsPage(),
        ),
        MyDashboardModel(
          icon: Icons.group_rounded,
          title: 'Users',
          widget: const MyUsersPage(),
        ),
        MyDashboardModel(
          icon: Icons.group_work_rounded,
          title: 'Media Members',
          widget: const MyMediaMembersPage(),
        ),
      ],
      MyDashboardModel(
        icon: Icons.line_style_rounded,
        title: 'Posts',
        widget: const MyPostsPage(),
      ),
      MyDashboardModel(
        icon: Icons.drafts_rounded,
        title: 'Draft Posts',
        widget: const MyDraftPostsPage(),
      ),
      MyDashboardModel(
        icon: Icons.privacy_tip_outlined,
        title: 'Privacy Policy',
        widget: MyPrivacyPolicy(dashboard: true),
      ),
    ];
    companyUniversalController.setSideBarController();
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<MyCompanyUniversalController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool style = (context.width < myDefaultMaxWidth || !context.isLandscape);
    return SafeArea(
      child: Scaffold(
        key: companyUniversalController.scaffoldKey,
        backgroundColor: MyColorHelper.white,
        drawer: style ? _MySideBar(_data) : null,
        body: MyResponsiveScreen(
          screen: Row(
            children: [
              if (context.width >= myDefaultMaxWidth && context.isLandscape)
                _MySideBar(_data),
              Expanded(
                child: Obx(
                  () => Column(
                    children: [
                      Container(
                        color: MyColorHelper.white,
                        height: kToolbarHeight * 1.25,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              style
                                  ? IconButton(
                                      onPressed: () =>
                                          companyUniversalController
                                              .scaffoldKey.currentState
                                              ?.openDrawer(),
                                      icon: const Icon(Icons.menu,
                                          color: MyColorHelper.black1),
                                    )
                                  : const SizedBox(width: 32.0),
                              Expanded(
                                child: Text(
                                    _data[companyUniversalController
                                            .sideBarController.selectedIndex]
                                        .title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: MyColorHelper.black1,
                                        fontSize: 20)),
                              ),
                              if ((companyUniversalController.tabIndex != 0 ||
                                      (companyUniversalController.tabIndex ==
                                              0 &&
                                          companyUniversalController
                                                  .currentUser.userType ==
                                              MyUserType.prMember)) &&
                                  companyUniversalController.tabIndex != 2 &&
                                  companyUniversalController.tabIndex != 4) ...[
                                InkWell(
                                  onTap: _onAdd,
                                  hoverColor: Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      companyUniversalController
                                          .actionButtonText,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                              ],
                              InkWell(
                                borderRadius: BorderRadius.circular(32.0),
                                onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => _MyProfileDialog(
                                          companyUniversalController
                                              .currentUser,
                                        )),
                                child: Obx(() => CircleAvatar(
                                      radius: companyUniversalController
                                              .profileUpdated
                                          ? 25
                                          : 25,
                                      backgroundImage:
                                          companyUniversalController.currentUser
                                                      .profilePicUrl ==
                                                  null
                                              ? const AssetImage(
                                                  'assets/images/default-profile.png',
                                                )
                                              : null,
                                      foregroundImage:
                                          companyUniversalController.currentUser
                                                      .profilePicUrl !=
                                                  null
                                              ? NetworkImage(
                                                  companyUniversalController
                                                      .currentUser
                                                      .profilePicUrl!)
                                              : null,
                                    )),
                              ),
                              const SizedBox(width: 16.0),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: ColoredBox(
                          color: MyColorHelper.white,
                          child: Container(
                            margin: EdgeInsets.only(
                                left: style ? 8.0 : 24.0,
                                right: 8.0,
                                bottom: 8.0),
                            decoration: BoxDecoration(
                              color: MyColorHelper.black.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: _data[companyUniversalController.tabIndex]
                                .widget,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onAdd() {
    if (widget.currentUser.userType != MyUserType.prMember) {
      companyUniversalController.tabIndex == 1
          ? showAddOrUpdateUserDialog(context)
          : companyUniversalController.tabIndex == 3
              ? showAddPostDialog(context)
              : null;
    } else {
      companyUniversalController.tabIndex == 0
          ? showAddPostDialog(context)
          : null;
    }
  }
}
