import 'package:app/company/controller/media_members_controller.dart';
import 'package:app/company/view/dashboard/screen.dart';
import 'package:app/helper/buttons/buttons.dart';
import 'package:app/helper/colors.dart';
import 'package:app/helper/dialog.dart';
import 'package:app/helper/snackbars.dart';
import 'package:app/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

part 'dialog.dart';

class MyMediaMembersPage extends StatefulWidget {
  const MyMediaMembersPage({super.key});

  @override
  State<MyMediaMembersPage> createState() => _MyMediaMembersPageState();
}

class _MyMediaMembersPageState extends State<MyMediaMembersPage> {
  MyMediaMembersController mediaMembersController =
      Get.put(MyMediaMembersController(companyUniversalController.currentUser));

  @override
  void dispose() {
    Get.delete<MyMediaMembersController>();
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
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: MyColorHelper.red1,
                      dividerColor: MyColorHelper.red1.withOpacity(0.10),
                      indicatorColor: MyColorHelper.red1,
                      indicatorSize: TabBarIndicatorSize.tab,
                      // onTap: (int i) =>
                      //     companyUniversalController.setUserTabIndex = i,
                      tabs: const [
                        Tab(text: 'Followers'),
                        Tab(text: 'Requests'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: (mediaMembersController.loading)
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
                            : (mediaMembersController.error != null)
                                ? [
                                    Center(
                                        child: Text(
                                      mediaMembersController.error!,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                    Center(
                                        child: Text(
                                      mediaMembersController.error!,
                                      overflow: TextOverflow.ellipsis,
                                    ))
                                  ]
                                : (mediaMembersController.mediaMembers.isEmpty)
                                    ? [
                                        const Center(
                                            child: Text(
                                          'No Followers found',
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                        const Center(
                                            child: Text(
                                          'No Requests found',
                                          overflow: TextOverflow.ellipsis,
                                        ))
                                      ]
                                    : [
                                        _widget(
                                            mediaMembersController.followers),
                                        _widget(
                                            mediaMembersController.requests),
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
              title: Text(list[i].fullName ?? 'Null'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: ${list[i].email ?? 'Null'}',
                      textAlign: TextAlign.center),
                  Text('Media Outlet Name: ${list[i].mediaOutletName ?? '-'}',
                      textAlign: TextAlign.center),
                ],
              ),
              trailing: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  color: MyColorHelper.red1.withOpacity(0.50),
                ),
                child: InkWell(
                  onTap: () => showDialog(
                      context: context,
                      builder: (context) =>
                          _MyDialog(list[i], mediaMembersController)),
                  child: const Text(
                    'View',
                    style: TextStyle(
                      fontSize: 14,
                      color: MyColorHelper.white,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, i) => const Divider(),
      );
}
