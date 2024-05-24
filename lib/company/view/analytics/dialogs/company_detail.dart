import 'package:app/helper/colors.dart';
import 'package:app/helper/designs.dart';
import 'package:app/model/company_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyCompanyDetailDialog extends StatefulWidget {
  const MyCompanyDetailDialog(this.model, {super.key});
  final MyCompanyModel model;

  @override
  State<MyCompanyDetailDialog> createState() => _MyCompanyDetailDialogState();
}

class _MyCompanyDetailDialogState extends State<MyCompanyDetailDialog> {
  TextEditingController companyName = TextEditingController();
  TextEditingController ownerName = TextEditingController();
  TextEditingController description = TextEditingController();
  // TextEditingController mailingAddress = TextEditingController();
  // TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();

  @override
  void initState() {
    companyName.text = widget.model.companyName ?? 'Null';
    ownerName.text = widget.model.ownerName ?? 'Null';
    description.text = widget.model.description ?? 'Null';
    // mailingAddress.text = widget.model.mailingAddress ?? 'Null';
    // phone.text = widget.model.phone ?? 'Null';
    email.text = widget.model.email ?? 'Null';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: MyColorHelper.black.withOpacity(0.95),
      scrollable: true,
      content: SizedBox(
        width: context.isLandscape ? 750 : 350,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  margin: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
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
              ],
            ),
            const SizedBox(height: 16.0),
            ...(context.isLandscape && context.width >= 750)
                ? _landscapeWidgets()
                : _portraitWidgets()
          ],
        ),
      ),
    );
  }

  List<Widget> _landscapeWidgets() => [
        Row(
          children: [
            Expanded(child: _companyNameWidget()),
            const SizedBox(width: 16.0),
            Expanded(child: _ownerNameWidget()),
          ],
        ),
        const SizedBox(height: 16.0),
        _descriptionWidget(),
        const SizedBox(height: 16.0),
        // _mailingAddress(),
        // const SizedBox(height: 16.0),
        // Row(
        //   children: [
        //     Expanded(child: _phoneWidget()),
        //     const SizedBox(width: 16.0),
        //     Expanded(child: _emailWidget()),
        //   ],
        // ),
        _emailWidget(),
        const SizedBox(height: 16.0),
      ];

  List<Widget> _portraitWidgets() => [
        _companyNameWidget(),
        const SizedBox(height: 16.0),
        _ownerNameWidget(),
        const SizedBox(height: 16.0),
        _descriptionWidget(),
        const SizedBox(height: 16.0),
        // _mailingAddress(),
        // const SizedBox(height: 16.0),
        // _phoneWidget(),
        // const SizedBox(height: 16.0),
        _emailWidget(),
        const SizedBox(height: 16.0),
      ];

  Widget _companyNameWidget() => TextFormField(
        enabled: false,
        controller: companyName,
        style: TextStyle(color: MyColorHelper.white.withOpacity(0.75)),
        decoration: MyDecorationHelper.textFieldDecoration(
          label: 'Company Name',
          labelColor: MyColorHelper.white,
          borderColor: MyColorHelper.white.withOpacity(0.10),
        ),
      );

  Widget _ownerNameWidget() => TextFormField(
        enabled: false,
        controller: ownerName,
        style: TextStyle(color: MyColorHelper.white.withOpacity(0.75)),
        decoration: MyDecorationHelper.textFieldDecoration(
          label: 'Owner\'s Name',
          labelColor: MyColorHelper.white,
          borderColor: MyColorHelper.white.withOpacity(0.10),
        ),
      );

  Widget _descriptionWidget() => TextFormField(
        maxLines: 2,
        enabled: false,
        controller: description,
        style: TextStyle(color: MyColorHelper.white.withOpacity(0.75)),
        decoration: MyDecorationHelper.textFieldDecoration(
          label: 'Description',
          labelColor: MyColorHelper.white,
          borderColor: MyColorHelper.white.withOpacity(0.10),
        ),
      );

  // Widget _mailingAddress() => TextFormField(
  //       enabled: false,
  //       controller: mailingAddress,
  //       style: TextStyle(color: MyColorHelper.white.withOpacity(0.75)),
  //       decoration: MyDecorationHelper.textFieldDecoration(
  //         label: 'Mailing Address',
  //         labelColor: MyColorHelper.white,
  //         borderColor: MyColorHelper.white.withOpacity(0.10),
  //       ),
  //     );
  //
  // Widget _phoneWidget() => TextFormField(
  //       enabled: false,
  //       controller: phone,
  //       style: TextStyle(color: MyColorHelper.white.withOpacity(0.75)),
  //       inputFormatters: [
  //         FilteringTextInputFormatter.allow(RegExp(r'^[0-9+]+$'))
  //       ],
  //       decoration: MyDecorationHelper.textFieldDecoration(
  //         label: 'Phone',
  //         hints: '+0123456789',
  //         labelColor: MyColorHelper.white,
  //         borderColor: MyColorHelper.white.withOpacity(0.10),
  //       ),
  //     );

  Widget _emailWidget() => TextFormField(
        enabled: false,
        controller: email,
        style: TextStyle(color: MyColorHelper.white.withOpacity(0.75)),
        decoration: MyDecorationHelper.textFieldDecoration(
          label: 'Email',
          labelColor: MyColorHelper.white,
          borderColor: MyColorHelper.white.withOpacity(0.10),
        ),
      );
}
