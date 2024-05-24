import 'package:app/admin/view/dashboard/screen.dart';
import 'package:app/helper/colors.dart';
import 'package:app/model/company_model.dart';
import 'package:flutter/material.dart';

class MyCompanyCards extends StatelessWidget {
  const MyCompanyCards({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: constraints.maxWidth > 750
            ? Row(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: adminUniversalController.companies.length,
                      itemBuilder: (context, i) => i % 2 == 0
                          ? _item(adminUniversalController.companies[i])
                          : const SizedBox.shrink(),
                      separatorBuilder: (context, i) =>
                          const SizedBox(height: 16.0),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: adminUniversalController.companies.length,
                      itemBuilder: (context, i) => i % 2 != 0
                          ? _item(adminUniversalController.companies[i])
                          : const SizedBox.shrink(),
                      separatorBuilder: (context, i) =>
                          SizedBox(height: i == 0 ? 0.0 : 16.0),
                    ),
                  ),
                ],
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16.0),
                itemCount: adminUniversalController.companies.length,
                itemBuilder: (context, i) =>
                    _item(adminUniversalController.companies[i]),
                separatorBuilder: (context, i) => const SizedBox(height: 16.0),
              ),
      ),
    );
  }

  Widget _item(MyCompanyModel model) {
    return InkWell(
      borderRadius: BorderRadius.circular(32.0),
      onTap: () => adminUniversalController.setSelectedCompany = model,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 32.0),
        decoration: BoxDecoration(
            color: MyColorHelper.white.withOpacity(0.75),
            borderRadius: BorderRadius.circular(32.0)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.companyName ?? 'Null',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Owner\'s Name: ${model.ownerName ?? 'Null'}',
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 32.0),
                  Card(
                    elevation: 6.0,
                    margin: const EdgeInsets.all(4.0),
                    color: MyColorHelper.red1.withOpacity(0.50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 32.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        'View Detail',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: MyColorHelper.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: MyColorHelper.red1.withOpacity(0.08),
                ),
                color: MyColorHelper.red1.withOpacity(0.05),
                image: model.logoUrl != null
                    ? DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          model.logoUrl!,
                        ))
                    : const DecorationImage(
                        image: AssetImage(
                        'assets/images/default-company-logo.png',
                      )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
