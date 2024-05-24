import 'package:app/admin/controller/analytics_controller.dart';
import 'package:app/admin/view/dialogs/company_detail.dart';
import 'package:app/admin/view/dialogs/post_detail.dart';
import 'package:app/admin/view/dialogs/user_detail.dart';
import 'package:app/helper/colors.dart';
import 'package:app/helper/rich_text_field.dart';
import 'package:app/model/company_model.dart';
import 'package:app/model/interactions_model.dart';
import 'package:app/model/post_model.dart';
import 'package:app/model/user_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

part 'charts/companies.dart';
part 'charts/interactions.dart';
part 'charts/posts.dart';
part 'charts/tiles.dart';
part 'charts/users.dart';
part 'tables/companies.dart';
part 'tables/interactions.dart';
part 'tables/posts.dart';
part 'tables/users.dart';

class MyAnalyticsPage extends StatefulWidget {
  const MyAnalyticsPage({super.key});

  @override
  State<MyAnalyticsPage> createState() => _MyAnalyticsPageState();
}

class _MyAnalyticsPageState extends State<MyAnalyticsPage> {
  final controller = Get.put(MyAnalyticsController());

  @override
  void dispose() {
    Get.delete<MyAnalyticsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: FutureBuilder(
        future: Future.delayed(1500.milliseconds),
        builder: (buildContext, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(
                    color: MyColorHelper.red1,
                  ))
                : TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth > 750) {
                              return Column(
                                children: [
                                  _postsAndCompanies(buildContext),
                                  _usersAndInteractions(buildContext),
                                ],
                              );
                            } else {
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 3 / 2,
                                      child: _posts(context),
                                    ),
                                    AspectRatio(
                                      aspectRatio: 3 / 2,
                                      child: _companies(context),
                                    ),
                                    AspectRatio(
                                      aspectRatio: 3 / 2,
                                      child: _users(context),
                                    ),
                                    AspectRatio(
                                      aspectRatio: 3 / 2,
                                      child: _interactions(context),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      _MyPostsTable(controller),
                      _MyCompaniesTable(controller),
                      _MyUsersTable(controller),
                      _MyInteractionsTable(controller),
                    ],
                  ),
      ),
    );
  }

  Widget _postsAndCompanies(BuildContext buildContext) => Expanded(
        child: Row(
          children: [
            Expanded(flex: 2, child: _posts(buildContext)),
            Expanded(flex: 1, child: _companies(buildContext)),
          ],
        ),
      );

  Widget _usersAndInteractions(BuildContext buildContext) => Expanded(
        child: Row(
          children: [
            Expanded(child: _users(buildContext)),
            Expanded(child: _interactions(buildContext)),
          ],
        ),
      );

  Widget _posts(BuildContext context) => _container(context,
      removeBottomPadding: true,
      label: 'Latest Posts',
      child: _MyLatestPosts(controller),
      onViewAll: () => DefaultTabController.of(context).animateTo(1));

  Widget _companies(BuildContext context) => _container(context,
      label: 'Companies',
      child:
          _MyCompaniesChart(controller, size: context.height < 750 ? 45 : 60),
      onViewAll: () => DefaultTabController.of(context).animateTo(2));

  Widget _users(BuildContext context) => _container(context,
      label: 'Overall Users',
      child: _MyUsersChart(controller),
      onViewAll: () => DefaultTabController.of(context).animateTo(3));

  Widget _interactions(BuildContext context) => _container(context,
      label: 'Interactions',
      child: _MyInteractionsChart(controller),
      onViewAll: () => DefaultTabController.of(context).animateTo(4));

  Widget _container(BuildContext context,
          {required String label,
          required Widget child,
          bool removeBottomPadding = false,
          required VoidCallback onViewAll}) =>
      Container(
        margin: const EdgeInsets.all(8.0),
        padding: removeBottomPadding
            ? const EdgeInsets.only(left: 32.0, top: 24.0, right: 32.0)
            : const EdgeInsets.symmetric(vertical: 24.0, horizontal: 32.0),
        decoration: BoxDecoration(
            color: MyColorHelper.white.withOpacity(0.75),
            borderRadius: BorderRadius.circular(32.0)),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                InkWell(
                  onTap: onViewAll,
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            const Divider(height: 0.0),
            child,
          ],
        ),
      );
}
