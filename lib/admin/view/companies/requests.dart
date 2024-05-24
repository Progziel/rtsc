import 'package:app/admin/view/dashboard/screen.dart';
import 'package:app/helper/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'cards.dart';
import 'company_detail.dart';

class MyRequestsPage extends StatefulWidget {
  const MyRequestsPage({super.key});

  @override
  State<MyRequestsPage> createState() => _MyRequestsPageState();
}

class _MyRequestsPageState extends State<MyRequestsPage> {
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
                        : MyCompanyDetail(
                            model: adminUniversalController.selectedCompany!,
                            request: true)
        // : FutureBuilder(
        //     future: adminUniversalController.loadData(),
        //     builder: (context, snapshot) => (snapshot
        //                 .connectionState ==
        //             ConnectionState.waiting)
        //         ? const Center(child: CircularProgressIndicator())
        //         : MyCompanyDetail(
        //             model:
        //                 adminUniversalController.selectedCompany!,
        //             request: true)),
        );
  }
}
