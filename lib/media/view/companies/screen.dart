import 'package:animations/animations.dart';
import 'package:app/helper/colors.dart';
import 'package:app/helper/dialog.dart';
import 'package:app/helper/snackbars.dart';
import 'package:app/media/controller/companies_controller.dart';
import 'package:app/media/controller/universal_controller.dart';
import 'package:app/model/company_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

part 'detail.dart';
part 'tile.dart';

class MyCompaniesPage extends StatefulWidget {
  const MyCompaniesPage({super.key});

  @override
  State<MyCompaniesPage> createState() => _MyCompaniesPageState();
}

class _MyCompaniesPageState extends State<MyCompaniesPage> {
  MyCompaniesController controller = Get.put(MyCompaniesController(
      Get.find<MyMediaUniversalController>().currentUser));

  @override
  void dispose() {
    Get.delete<MyCompaniesController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: (controller.loading)
            ? const [
                Center(
                    child: CircularProgressIndicator(
                  color: MyColorHelper.red1,
                ))
              ]
            : (controller.error != null)
                ? [
                    Center(
                        child: Text(controller.error!,
                            overflow: TextOverflow.ellipsis))
                  ]
                : (controller.companies.isEmpty)
                    ? [
                        const Center(
                            child: Text(
                          'Companies not found',
                          overflow: TextOverflow.ellipsis,
                        ))
                      ]
                    : [
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.all(8.0),
                            itemCount: controller.companies.length,
                            itemBuilder: (context, i) {
                              return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: _MyTile(
                                    model: controller.companies[i],
                                    controller: controller,
                                  ));
                            },
                            separatorBuilder: (context, i) => const Divider(),
                          ),
                        )
                      ],
      ),
    );
  }
}
