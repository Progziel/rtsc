import 'package:app/admin/view/companies/dialog.dart';
import 'package:app/admin/view/dashboard/screen.dart';
import 'package:app/helper/colors.dart';
import 'package:app/model/company_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyArchivedPage extends StatelessWidget {
  const MyArchivedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: (adminUniversalController.loading)
            ? const [
                Center(
                    child: CircularProgressIndicator(
                  color: MyColorHelper.red1,
                ))
              ]
            : (adminUniversalController.error != null)
                ? [
                    Center(
                        child: Text(adminUniversalController.error!,
                            overflow: TextOverflow.ellipsis))
                  ]
                : (adminUniversalController.companies.isEmpty)
                    ? [
                        const Center(
                            child: Text('No Archived found',
                                overflow: TextOverflow.ellipsis))
                      ]
                    : [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DefaultTabController(
                              length: 2,
                              child: Column(
                                children: [
                                  TabBar(
                                    labelColor: MyColorHelper.red1,
                                    dividerColor:
                                        MyColorHelper.red1.withOpacity(0.10),
                                    indicatorColor: MyColorHelper.red1,
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    tabs: const [
                                      Tab(text: 'Inactive'),
                                      Tab(text: 'Rejected'),
                                    ],
                                  ),
                                  Expanded(
                                    child: TabBarView(
                                      children: [
                                        _widget(adminUniversalController
                                            .companies
                                            .where((e) => e.register == true)
                                            .toList()),
                                        _widget(adminUniversalController
                                            .companies
                                            .where((e) => e.register == false)
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

  Widget _widget(List<MyCompanyModel> list) => ListView.separated(
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
                  image: list[i].logoUrl != null
                      ? DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            list[i].logoUrl!,
                          ))
                      : const DecorationImage(
                          image: AssetImage(
                          'assets/images/default-company-logo.png',
                        )),
                ),
              ),
              title: Text(list[i].companyName ?? 'Null'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email: ${list[i].email ?? 'Null'}',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Description: ${list[i].companyName ?? 'Null'}',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              trailing: Card(
                elevation: 6.0,
                margin: const EdgeInsets.all(4.0),
                color: MyColorHelper.red1.withOpacity(0.50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => showDialog(
                      context: context,
                      builder: (context) => MyDialog(list[i], archived: true)),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
                    child: Text(
                      'Activate',
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MyColorHelper.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              // trailing: MyViewButton(
              //   onTap: () => showDialog(
              //       context: context,
              //       builder: (context) => MyDialog(list[i], archived: true)),
              // ),
            ),
          );
        },
        separatorBuilder: (context, i) => const Divider(),
      );
}
