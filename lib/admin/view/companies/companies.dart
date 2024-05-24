import 'package:app/admin/view/companies/company_detail.dart';
import 'package:app/admin/view/dashboard/screen.dart';
import 'package:app/helper/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'cards.dart';

class MyCompaniesPage extends StatelessWidget {
  const MyCompaniesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => (adminUniversalController.loading)
        ? const Center(
            child: CircularProgressIndicator(
            color: MyColorHelper.red1,
          ))
        : (adminUniversalController.error != null)
            ? Center(
                child: Text(adminUniversalController.error!,
                    overflow: TextOverflow.ellipsis))
            : (adminUniversalController.companies.isEmpty)
                ? const Center(
                    child: Text('No Requests found',
                        overflow: TextOverflow.ellipsis))
                : adminUniversalController.selectedCompany == null
                    ? const MyCompanyCards()
                    : FutureBuilder(
                        future: adminUniversalController.loadCompanyData(),
                        builder: (context, snapshot) => (snapshot
                                    .connectionState ==
                                ConnectionState.waiting)
                            ? const Center(
                                child: CircularProgressIndicator(
                                color: MyColorHelper.red1,
                              ))
                            : MyCompanyDetail(
                                model:
                                    adminUniversalController.selectedCompany!,
                              )));
  }
}
