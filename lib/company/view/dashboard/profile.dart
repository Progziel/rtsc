part of 'screen.dart';

class _MyProfileDialog extends StatelessWidget {
  const _MyProfileDialog(this.model);
  final MyUserModel model;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      content: SizedBox(
        width: 750,
        child: Obx(
          () => Stack(
            alignment: companyUniversalController.profileUpdated
                ? Alignment.topCenter
                : Alignment.topCenter,
            children: [
              Container(
                width: 750,
                padding: EdgeInsets.symmetric(
                    vertical: 48.0,
                    horizontal: context.width > 750 ? 96.0 : 24.0),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) =>
                                  _MyUpdateProfileDialog(model: model)),
                          child: Row(
                            children: [
                              const Icon(Icons.edit_rounded,
                                  color: MyColorHelper.red1),
                              if (context.width > 500) ...[
                                const SizedBox(width: 4.0),
                                const Text('Edit',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: MyColorHelper.red1,
                                    )),
                              ],
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await FirebaseAuth.instance.signOut();
                            Get.offAllNamed('/');
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
                      model.fullName ?? 'Null',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                    Text(model.email ?? 'Null'),
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
                          model.phone ?? 'Null',
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
                            model.userType!.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ]),
                    const SizedBox(height: 48.0),
                    MyButtonHelper.simpleButton(
                        borderColor: MyColorHelper.red1,
                        buttonColor: MyColorHelper.red1,
                        buttonText: 'Change Password',
                        onTap: () => showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) =>
                                const _MyUpdatePasswordDialog()))
                  ],
                ),
              ),
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: MyColorHelper.white),
                    color: MyColorHelper.white.withOpacity(0.95),
                    image: model.profilePicUrl != null
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              model.profilePicUrl!,
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
            ],
          ),
        ),
      ),
    );
  }
}

class _MyUpdateProfileDialog extends StatefulWidget {
  const _MyUpdateProfileDialog({required this.model});
  final MyUserModel model;

  @override
  State<_MyUpdateProfileDialog> createState() => _MyUpdateProfileDialogState();
}

class _MyUpdateProfileDialogState extends State<_MyUpdateProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  final loading = false.obs, error = ''.obs;
  TextEditingController email = TextEditingController();
  TextEditingController fullName = TextEditingController();
  TextEditingController phone = TextEditingController();
  final _image = Rx<Uint8List?>(null);

  @override
  void initState() {
    email.text = widget.model.email ?? 'Null';
    fullName.text = widget.model.fullName ?? 'Null';
    phone.text = widget.model.phone ?? 'Null';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AlertDialog(
        scrollable: true,
        title: const Center(child: Text('Update Profile')),
        content: SizedBox(
          width: 400,
          child: Form(
            key: _formKey,
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
                          : widget.model.profilePicUrl != null
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
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  enabled: false,
                  controller: email,
                  onChanged: (value) =>
                      (error.isNotEmpty) ? error.value = '' : null,
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Required*' : null,
                  decoration: MyDecorationHelper.textFieldDecoration(
                    borderColor: MyColorHelper.black1.withOpacity(0.10),
                    prefixIcon: Icons.email_rounded,
                    label: 'Email',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  enabled: !loading.value,
                  controller: fullName,
                  onChanged: (value) =>
                      (error.isNotEmpty) ? error.value = '' : null,
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Required*' : null,
                  decoration: MyDecorationHelper.textFieldDecoration(
                    borderColor: MyColorHelper.black1.withOpacity(0.10),
                    prefixIcon: Icons.person_rounded,
                    label: 'Full Name',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  enabled: !loading.value,
                  controller: phone,
                  onChanged: (value) =>
                      (error.isNotEmpty) ? error.value = '' : null,
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Required*' : null,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[0-9+]+$'))
                  ],
                  decoration: MyDecorationHelper.textFieldDecoration(
                    borderColor: MyColorHelper.black1.withOpacity(0.10),
                    prefixIcon: Icons.phone_rounded,
                    label: 'Phone',
                    hints: '+0123456789',
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
                              loading.value = true;
                              String? str = await companyUniversalController
                                  .updateProfile(_image.value,
                                      fullName.text.trim(), phone.text.trim());
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
                                String? str = await companyUniversalController
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
