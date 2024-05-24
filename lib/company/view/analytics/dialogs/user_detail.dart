import 'package:app/helper/colors.dart';
import 'package:app/helper/designs.dart';
import 'package:app/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyUserDetailDialog extends StatefulWidget {
  const MyUserDetailDialog(this.model);
  final MyUserModel model;

  @override
  State<MyUserDetailDialog> createState() => _MyUserDetailDialogState();
}

class _MyUserDetailDialogState extends State<MyUserDetailDialog> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _fullName = TextEditingController();
  final _phone = TextEditingController();
  final _status = TextEditingController();
  final _mediaOutletName = TextEditingController();

  @override
  void initState() {
    _email.text = widget.model.email ?? 'Null';
    _password.text = widget.model.password ?? 'Null';
    _fullName.text = widget.model.fullName ?? 'Null';
    _phone.text = widget.model.phone ?? 'Null';
    _mediaOutletName.text = widget.model.mediaOutletName ?? 'Null';
    _status.text = (widget.model.status != null && widget.model.status == true)
        ? 'Active'
        : 'Inactive';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Center(child: Text('User Detail')),
        ),
      ),
      content: Column(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: MyColorHelper.red1.withOpacity(0.08),
              ),
              color: MyColorHelper.red1.withOpacity(0.05),
              image: widget.model.profilePicUrl != null
                  ? DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        widget.model.profilePicUrl!,
                      ))
                  : const DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        'assets/images/default-profile.png',
                      )),
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            enabled: false,
            controller: _email,
            decoration: MyDecorationHelper.textFieldDecoration(
              borderColor: MyColorHelper.black1.withOpacity(0.10),
              prefixIcon: Icons.email_rounded,
              label: 'Email',
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            enabled: false,
            controller: _password,
            decoration: MyDecorationHelper.textFieldDecoration(
              borderColor: MyColorHelper.black1.withOpacity(0.10),
              prefixIcon: Icons.lock_rounded,
              label: 'Password',
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            enabled: false,
            controller: _fullName,
            decoration: MyDecorationHelper.textFieldDecoration(
              borderColor: MyColorHelper.black1.withOpacity(0.10),
              prefixIcon: Icons.person_rounded,
              label: 'Full Name',
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            enabled: false,
            controller: _phone,
            decoration: MyDecorationHelper.textFieldDecoration(
              borderColor: MyColorHelper.black1.withOpacity(0.10),
              prefixIcon: Icons.phone_rounded,
              label: 'Phone',
              hints: '+0123456789',
            ),
          ),
          if (widget.model.mediaOutletName != null) ...[
            const SizedBox(height: 16.0),
            TextFormField(
              enabled: false,
              controller: _mediaOutletName,
              decoration: MyDecorationHelper.textFieldDecoration(
                borderColor: MyColorHelper.black1.withOpacity(0.10),
                prefixIcon: Icons.apartment_rounded,
                label: 'Media Outlet Name',
                hints: '-',
              ),
            ),
          ],
          const SizedBox(height: 16.0),
          TextFormField(
            enabled: false,
            controller: _status,
            decoration: MyDecorationHelper.textFieldDecoration(
              borderColor: MyColorHelper.black1.withOpacity(0.10),
              prefixIcon: Icons.circle_rounded,
              label: 'Status',
              hints: '-',
            ),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        InkWell(
          hoverColor: Colors.transparent,
          child: const Text('Ok'),
          onTap: () => Get.back(),
        )
      ],
    );
  }
}
