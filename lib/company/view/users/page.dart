import 'package:app/company/controller/users_controller.dart';
import 'package:app/company/view/dashboard/screen.dart';
import 'package:app/helper/buttons/buttons.dart';
import 'package:app/helper/colors.dart';
import 'package:app/helper/designs.dart';
import 'package:app/helper/dropdown.dart';
import 'package:app/helper/image_picker.dart';
import 'package:app/helper/snackbars.dart';
import 'package:app/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

part 'dialog.dart';

class MyUsersPage extends StatefulWidget {
  const MyUsersPage({super.key});

  @override
  State<MyUsersPage> createState() => _MyUsersPageState();
}

class _MyUsersPageState extends State<MyUsersPage> {
  MyUsersController usersController =
      Get.put(MyUsersController(companyUniversalController.currentUser));

  @override
  void initState() {
    companyUniversalController.setUserTabIndex = 0;
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<MyUsersController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DefaultTabController(
                initialIndex: companyUniversalController.userTabIndex,
                length: companyUniversalController.currentUser.userType ==
                        MyUserType.admin
                    ? 2
                    : 1,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: MyColorHelper.red1,
                      dividerColor: MyColorHelper.red1.withOpacity(0.10),
                      indicatorColor: MyColorHelper.red1,
                      indicatorSize: TabBarIndicatorSize.tab,
                      onTap: (int i) =>
                          companyUniversalController.setUserTabIndex = i,
                      tabs: [
                        if (companyUniversalController.currentUser.userType ==
                            MyUserType.admin)
                          const Tab(text: 'Management'),
                        const Tab(text: 'PR Members'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: (usersController.loading)
                            ? const [
                                Center(
                                    child: CircularProgressIndicator(
                                  color: MyColorHelper.red1,
                                )),
                                Center(
                                    child: CircularProgressIndicator(
                                  color: MyColorHelper.red1,
                                )),
                              ]
                            : (usersController.error != null)
                                ? [
                                    Center(
                                        child: Text(
                                      usersController.error!,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                    Center(
                                        child: Text(
                                      usersController.error!,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                  ]
                                : (usersController.users.isEmpty)
                                    ? [
                                        const Center(
                                            child: Text(
                                          'No Management Member found',
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                        const Center(
                                            child: Text(
                                          'No PR Member found',
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                      ]
                                    : [
                                        if (companyUniversalController
                                                .currentUser.userType ==
                                            MyUserType.admin)
                                          _widget(usersController.users
                                              .where((e) =>
                                                  e.userType == MyUserType.user)
                                              .toList()),
                                        _widget(usersController.users
                                            .where((e) =>
                                                e.userType ==
                                                MyUserType.prMember)
                                            .toList()),
                                      ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _widget(List<MyUserModel> list) => ListView.separated(
        padding: const EdgeInsets.all(8.0),
        itemCount: list.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              contentPadding: const EdgeInsets.all(8.0),
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: MyColorHelper.black1.withOpacity(0.50),
                  ),
                  borderRadius: BorderRadius.circular(8.0)),
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: MyColorHelper.red1.withOpacity(0.08),
                  ),
                  color: MyColorHelper.red1.withOpacity(0.05),
                  image: list[i].profilePicUrl != null
                      ? DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            list[i].profilePicUrl!,
                          ))
                      : const DecorationImage(
                          image: AssetImage(
                          'assets/images/default-profile.png',
                        )),
                ),
              ),
              title: Text(
                list[i].fullName ?? 'Null',
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email: ${list[i].email ?? 'Null'}',
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Phone: ${list[i].phone ?? 'Null'}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              onTap: () => showAddOrUpdateUserDialog(context, model: list[i]),
              trailing: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  color: list[i].status == null
                      ? Colors.blue.withOpacity(0.75)
                      : list[i].status!
                          ? Colors.green.withOpacity(0.75)
                          : Colors.red.withOpacity(0.75),
                ),
                child: Text(
                  list[i].status == null
                      ? 'Null'
                      : list[i].status!
                          ? 'Active'
                          : 'Inactive',
                  style:
                      const TextStyle(fontSize: 14, color: MyColorHelper.white),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, i) => const Divider(),
      );
}
