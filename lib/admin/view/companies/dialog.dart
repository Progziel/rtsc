import 'package:app/admin/view/dashboard/screen.dart';
import 'package:app/helper/buttons/buttons.dart';
import 'package:app/helper/colors.dart';
import 'package:app/model/company_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDialog extends StatefulWidget {
  const MyDialog(this.model, {super.key, this.archived});
  final MyCompanyModel model;
  final bool? archived;

  @override
  State<MyDialog> createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  final _loading = false.obs;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AlertDialog(
        scrollable: true,
        icon: Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: MyColorHelper.red1.withOpacity(0.08),
              ),
              color: MyColorHelper.red1.withOpacity(0.05),
              image: widget.model.logoUrl != null
                  ? DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        widget.model.logoUrl!,
                      ))
                  : const DecorationImage(
                      image: AssetImage(
                      'assets/images/default-company-logo.png',
                    )),
            ),
          ),
        ),
        title: SizedBox(
            width: 400, child: Text(widget.model.companyName ?? 'Null')),
        content: Column(
          children: [
            _detail('Owner\'s Name', widget.model.ownerName),
            // _detail('Mailing Address', widget.model.mailingAddress),
            // _detail('Phone', widget.model.phone),
            _detail('Email', widget.model.email),
            const SizedBox(height: 24.0),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          _loading.value
              ? const CircularProgressIndicator(color: MyColorHelper.red1)
              : _error != null
                  ? Text(_error!, style: const TextStyle(color: Colors.red))
                  : (widget.model.register == null &&
                          widget.model.status == null)
                      ? Row(
                          children: [
                            Expanded(
                              child: MyButtonHelper.simpleButton(
                                buttonColor: Colors.green,
                                borderColor: Colors.green,
                                buttonText: 'Activate',
                                padding: 8.0,
                                onTap: () =>
                                    _onAction(context, widget.model, true),
                              ),
                            ),
                            Expanded(
                              child: MyButtonHelper.simpleButton(
                                buttonColor: Colors.red,
                                borderColor: Colors.red,
                                buttonText: 'Reject',
                                padding: 8.0,
                                onTap: () =>
                                    _onAction(context, widget.model, false),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: MyButtonHelper.simpleButton(
                                buttonColor: widget.model.status!
                                    ? Colors.red
                                    : Colors.green,
                                borderColor: widget.model.status!
                                    ? Colors.red
                                    : Colors.green,
                                buttonText: widget.model.status!
                                    ? 'Deactivate'
                                    : 'Activate',
                                padding: 8.0,
                                onTap: () => _onAction(context, widget.model,
                                    !widget.model.status!),
                              ),
                            ),
                          ],
                        )
        ],
      ),
    );
  }

  Widget _detail(String str1, String? str2) => Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Expanded(
                child: Text('$str1: ',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ))),
            Text(
              str2 ?? 'Null',
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );

  void _onAction(BuildContext context, MyCompanyModel model, bool value) async {
    _loading.value = true;
    if ((widget.model.register == null && widget.model.status == null) ||
        value) {
      model.register = value;
    }
    model.status = value;
    String? response = await adminUniversalController.onCompanyAction(model);
    adminUniversalController.setSelectedCompany = null;
    response == null ? Get.back() : _error = response;
  }
}
