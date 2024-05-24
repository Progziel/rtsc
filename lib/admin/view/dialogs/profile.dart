import 'dart:typed_data';

import 'package:app/admin/view/dashboard/screen.dart';
import 'package:app/helper/buttons/buttons.dart';
import 'package:app/helper/colors.dart';
import 'package:app/helper/designs.dart';
import 'package:app/helper/image_picker.dart';
import 'package:app/helper/snackbars.dart';
import 'package:app/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyProfileDialog extends StatelessWidget {
  const MyProfileDialog({super.key, this.model});
  final MyUserModel? model;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      content: SizedBox(
        width: model != null ? 750 : 500,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: model != null ? 750 : 500,
              padding:
                  const EdgeInsets.symmetric(vertical: 48.0, horizontal: 24.0),
              margin: const EdgeInsets.only(top: 50),
              decoration: BoxDecoration(
                  border: Border.all(color: MyColorHelper.white),
                  color: MyColorHelper.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(32.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5, //spread radius
                      blurRadius: 7, // blur radius
                      offset: const Offset(0, 2),
                    ),
                  ]),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          Get.offAllNamed('/admin');
                        },
                        child: Row(
                          children: [
                            if (context.width > 500) ...[
                              const Text('Logout',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: MyColorHelper.red1,
                                  )),
                              const SizedBox(width: 4.0),
                            ],
                            const Icon(Icons.logout_rounded,
                                color: MyColorHelper.red1),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 75.0),
                  Text(
                    model != null ? model!.fullName ?? 'Null' : 'Admin',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                  if (model != null) ...[
                    Text(model!.email ?? 'Null'),
                    const SizedBox(height: 24.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Phone: ',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          model!.phone ?? 'Null',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'User Type: ',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            model!.userType!.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ]),
                  ],
                  SizedBox(height: model != null ? 48.0 : 24.0),
                  MyButtonHelper.simpleButton(
                      borderColor: MyColorHelper.red1,
                      buttonColor: MyColorHelper.red1,
                      buttonText: model != null ? 'Close' : 'Change Password',
                      onTap: () {
                        model != null
                            ? Get.back()
                            : showDialog(
                                context: context,
                                builder: (context) =>
                                    const _MyUpdatePasswordDialog());
                      })
                ],
              ),
            ),
            InkWell(
              onTap: model != null
                  ? null
                  : () => showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (dContext) => const _MyUpdateProfileDialog()),
              child: Obx(
                () => Container(
                  width: adminUniversalController.profilePicUrl.value == null
                      ? 150
                      : 150,
                  height: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: MyColorHelper.white),
                      color: MyColorHelper.white.withOpacity(0.95),
                      image: (adminUniversalController.profilePicUrl.value !=
                                  null ||
                              (model != null && model!.profilePicUrl != null))
                          ? DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                adminUniversalController.profilePicUrl.value !=
                                        null
                                    ? adminUniversalController
                                        .profilePicUrl.value!
                                    : model!.profilePicUrl!,
                              ))
                          : const DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                'assets/images/default-profile.png',
                              )),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5, //spread radius
                          blurRadius: 7, // blur radius
                          offset: const Offset(0, 2),
                        ),
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyUpdateProfileDialog extends StatefulWidget {
  const _MyUpdateProfileDialog();

  @override
  State<_MyUpdateProfileDialog> createState() => _MyUpdateProfileDialogState();
}

class _MyUpdateProfileDialogState extends State<_MyUpdateProfileDialog> {
  final loading = false.obs, error = ''.obs;
  final _image = Rx<Uint8List?>(null);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AlertDialog(
        scrollable: true,
        title: const Center(child: Text('Update Profile')),
        content: SizedBox(
          width: 400,
          child: Column(
            children: [
              InkWell(
                onTap: () => imagePicker(context,
                    onSelect: (Uint8List? pickedFile) =>
                        _image.value = pickedFile),
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: MyColorHelper.red1.withOpacity(0.08),
                    ),
                    color: MyColorHelper.red1.withOpacity(0.05),
                    image: _image.value != null
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            image: MemoryImage(_image.value!),
                          )
                        : adminUniversalController.profilePicUrl.value != null
                            ? DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  adminUniversalController.profilePicUrl.value!,
                                ))
                            : const DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  'assets/images/default-profile.png',
                                )),
                  ),
                ),
              ),
            ],
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          loading.value
              ? const CircularProgressIndicator(color: MyColorHelper.red1)
              : error.isNotEmpty
                  ? Text(error.value,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.red))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => Get.back(),
                          hoverColor: Colors.transparent,
                          child: const Text('Cancel'),
                        ),
                        InkWell(
                          onTap: () async {
                            if (_image.value != null) {
                              loading.value = true;
                              String? str = await adminUniversalController
                                  .updateProfile(_image.value!);
                              if (str != null) error.value = str;
                              error.isEmpty
                                  ? Get.back()
                                  : loading.value = false;
                            }
                          },
                          hoverColor: Colors.transparent,
                          child: const Text('Update'),
                        ),
                      ],
                    )
        ],
      ),
    );
  }
}

class _MyUpdatePasswordDialog extends StatefulWidget {
  const _MyUpdatePasswordDialog();

  @override
  State<_MyUpdatePasswordDialog> createState() =>
      _MyUpdatePasswordDialogState();
}

class _MyUpdatePasswordDialogState extends State<_MyUpdatePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final loading = false.obs, error = ''.obs;
  TextEditingController currentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AlertDialog(
        scrollable: true,
        title: const Center(child: Text('Change Password')),
        content: SizedBox(
          width: 400,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: currentPassword,
                  onChanged: (value) =>
                      (error.isNotEmpty) ? error.value = '' : null,
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Required*' : null,
                  decoration: MyDecorationHelper.textFieldDecoration(
                    borderColor: MyColorHelper.black1.withOpacity(0.10),
                    prefixIcon: Icons.lock_rounded,
                    label: 'Current Password',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  enabled: !loading.value,
                  controller: newPassword,
                  onChanged: (value) =>
                      (error.isNotEmpty) ? error.value = '' : null,
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Required*' : null,
                  decoration: MyDecorationHelper.textFieldDecoration(
                    borderColor: MyColorHelper.black1.withOpacity(0.10),
                    prefixIcon: Icons.lock_outlined,
                    label: 'New Password',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  enabled: !loading.value,
                  controller: confirmPassword,
                  onChanged: (value) =>
                      (error.isNotEmpty) ? error.value = '' : null,
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Required*' : null,
                  decoration: MyDecorationHelper.textFieldDecoration(
                    borderColor: MyColorHelper.black1.withOpacity(0.10),
                    prefixIcon: Icons.lock_outlined,
                    label: 'Confirm Password',
                  ),
                ),
              ],
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          loading.value
              ? const CircularProgressIndicator(color: MyColorHelper.red1)
              : error.isNotEmpty
                  ? Text(error.value,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.red))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => Get.back(),
                          hoverColor: Colors.transparent,
                          child: const Text('Cancel'),
                        ),
                        InkWell(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              if (newPassword.text.trim() ==
                                  confirmPassword.text.trim()) {
                                loading.value = true;
                                String? str = await adminUniversalController
                                    .changePassword(currentPassword.text.trim(),
                                        newPassword.text.trim());
                                if (str != null) error.value = str;
                                error.isEmpty
                                    ? Get.back()
                                    : loading.value = false;
                              } else {
                                MySnackBarsHelper.showError(
                                    'Password not matched');
                              }
                            }
                          },
                          hoverColor: Colors.transparent,
                          child: const Text('Change'),
                        ),
                      ],
                    )
        ],
      ),
    );
  }
}
