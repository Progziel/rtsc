import 'package:app/admin/controller/adminUniversal_controller.dart';
import 'package:app/admin/view/analytics/page.dart';
import 'package:app/admin/view/companies/archived.dart';
import 'package:app/admin/view/companies/companies.dart';
import 'package:app/admin/view/companies/requests.dart';
import 'package:app/admin/view/dialogs/profile.dart';
import 'package:app/admin/view/user_support/page.dart';
import 'package:app/helper/colors.dart';
import 'package:app/helper/responsive.dart';
import 'package:app/model/dashboard_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidebarx/sidebarx.dart';

part 'side_bar.dart';

late MyAdminUniversalController adminUniversalController;

class MyAdminDashboardScreen extends StatefulWidget {
  const MyAdminDashboardScreen({super.key});

  @override
  State<MyAdminDashboardScreen> createState() => _MyAdminDashboardScreenState();
}

class _MyAdminDashboardScreenState extends State<MyAdminDashboardScreen> {
  late GlobalKey<ScaffoldState> _key;
  late List<MyDashboardModel> _data;
  late SidebarXController _sideBarController;
  @override
  void initState() {
    adminUniversalController = MyAdminUniversalController();
    adminUniversalController.loadProfilePic();
    _key = GlobalKey<ScaffoldState>();
    _data = [
      MyDashboardModel(
        icon: Icons.dashboard_rounded,
        title: 'Analytics',
        widget: const MyAnalyticsPage(),
      ),
      MyDashboardModel(
        icon: Icons.list_alt_rounded,
        title: 'Requests',
        widget: const MyRequestsPage(),
      ),
      MyDashboardModel(
        icon: Icons.apartment_rounded,
        title: 'Companies',
        widget: const MyCompaniesPage(),
      ),
      MyDashboardModel(
        icon: Icons.folder_open_rounded,
        title: 'Archived',
        widget: const MyArchivedPage(),
      ),
      MyDashboardModel(
        icon: Icons.support_agent_rounded,
        title: 'User Support',
        widget: MyUserSupportPage(),
      ),
    ];
    _sideBarController = SidebarXController(
        selectedIndex: adminUniversalController.tabIndex, extended: true);
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<MyAdminUniversalController>();
    super.dispose();
  }

  bool _style() => (context.width < myDefaultMaxWidth || !context.isLandscape);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MyResponsiveScreen(
        screen: Scaffold(
          key: _key,
          backgroundColor: MyColorHelper.white,
          drawer: _style() ? _MySideBar(_sideBarController, _data, _key) : null,
          body: Row(
            children: [
              if (context.width >= myDefaultMaxWidth && context.isLandscape)
                _MySideBar(_sideBarController, _data, _key),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      color: MyColorHelper.white,
                      height: kToolbarHeight * 1.25,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            _style()
                                ? IconButton(
                                    onPressed: () =>
                                        _key.currentState?.openDrawer(),
                                    icon: const Icon(Icons.menu,
                                        color: MyColorHelper.black1),
                                  )
                                : const SizedBox(width: 32.0),
                            Expanded(
                              child: Text(
                                  _data[_sideBarController.selectedIndex].title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: MyColorHelper.black1,
                                      fontSize: 20)),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(32.0),
                              onTap: () => showDialog(
                                  context: context,
                                  builder: (context) =>
                                      const MyProfileDialog()),
                              child: Obx(() => CircleAvatar(
                                    radius: 25,
                                    backgroundImage: adminUniversalController
                                                .profilePicUrl.value ==
                                            null
                                        ? const AssetImage(
                                            'assets/images/default-profile.png',
                                          )
                                        : null,
                                    foregroundImage: adminUniversalController
                                                .profilePicUrl.value !=
                                            null
                                        ? NetworkImage(
                                            adminUniversalController
                                                .profilePicUrl.value!,
                                          )
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
                              left: _style() ? 8.0 : 24.0,
                              right: 8.0,
                              bottom: 8.0),
                          decoration: BoxDecoration(
                            color: MyColorHelper.black.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Obx(() =>
                              _data[adminUniversalController.tabIndex].widget),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
