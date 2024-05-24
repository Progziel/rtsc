part of 'screen.dart';

class _MyProfilePage extends StatefulWidget {
  const _MyProfilePage();

  @override
  State<_MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<_MyProfilePage> {
  final _controller = Get.find<MyMediaUniversalController>();
  final _edit = false.obs, _image = Rx<Uint8List?>(null);
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _mediaOutletName = TextEditingController();

  @override
  void initState() {
    _fullName.text = _controller.currentUser.fullName ?? 'Null';
    _phone.text = _controller.currentUser.phone ?? 'Null';
    _email.text = _controller.currentUser.email ?? 'Null';
    _mediaOutletName.text = _controller.currentUser.mediaOutletName ?? 'Null';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: MyColorHelper.red1,
            foregroundColor: MyColorHelper.white,
            automaticallyImplyLeading: true,
            elevation: 0,
            title: Text(
              'Profile',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              _edit.value
                  ? Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: InkWell(
                        onTap: () {
                          _image.value = null;
                          _edit.value = false;
                        },
                        child: Icon(Icons.close_rounded),
                      ),
                    )
                  : PopupMenuButton<String>(
                      color: Colors.red.shade50,
                      onSelected: (value) async {
                        // Handle the selected menu item
                        switch (value) {
                          case 'Edit':
                            {
                              _edit.value = !_edit.value;
                              break;
                            }
                          case 'Logout':
                            {
                              await FirebaseAuth.instance.signOut();
                              Get.offAll(() => const MyMediaAuthScreen());
                              break;
                            }
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return {'Edit', 'Logout'}.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: SizedBox(
                              width: 100,
                              child: Row(
                                children: [
                                  Icon(
                                    choice == 'Edit'
                                        ? Icons.edit_rounded
                                        : Icons.logout_rounded,
                                    color: Colors.black87,
                                  ),
                                  SizedBox(width: 16.0),
                                  Text(choice),
                                ],
                              ),
                            ),
                          );
                        }).toList();
                      },
                    ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 16.0),
                        Center(
                          child: InkWell(
                            onTap: _edit.value
                                ? () async {
                                    final status =
                                        await Permission.storage.request();
                                    if (status.isGranted) {
                                      XFile? image = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.gallery);
                                      if (image != null) {
                                        _image.value =
                                            await image.readAsBytes();
                                      }
                                    }
                                  }
                                : null,
                            child: Container(
                              width: 120,
                              height: 120,
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
                                    : _controller.currentUser.profilePicUrl !=
                                            null
                                        ? DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                              _controller
                                                  .currentUser.profilePicUrl!,
                                            ))
                                        : const DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                              'assets/images/default-profile.png',
                                            )),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.0),
                        TextFormField(
                          controller: _fullName,
                          enabled: _edit.value,
                          validator: (v) =>
                              (v == null || v.isEmpty) ? 'Required*' : null,
                          decoration: MyDecorationHelper.textFieldDecoration(
                            prefixIcon: Icons.person_rounded,
                            label: 'Full Name',
                            borderColor: MyColorHelper.black1.withOpacity(0.50),
                            backgroundColor:
                                MyColorHelper.white.withOpacity(0.50),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          enabled: false,
                          controller: _email,
                          validator: (v) =>
                              (v == null || v.isEmpty) ? 'Required*' : null,
                          decoration: MyDecorationHelper.textFieldDecoration(
                            prefixIcon: Icons.email,
                            label: 'Email',
                            borderColor: MyColorHelper.black1.withOpacity(0.50),
                            backgroundColor:
                                MyColorHelper.white.withOpacity(0.50),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _phone,
                          enabled: _edit.value,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^[0-9+]+$'))
                          ],
                          decoration: MyDecorationHelper.textFieldDecoration(
                            prefixIcon: Icons.phone_rounded,
                            label: 'Phone',
                            borderColor: MyColorHelper.black1.withOpacity(0.50),
                            backgroundColor:
                                MyColorHelper.white.withOpacity(0.50),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _mediaOutletName,
                          enabled: _edit.value,
                          validator: (v) =>
                              (v == null || v.isEmpty) ? 'Required*' : null,
                          decoration: MyDecorationHelper.textFieldDecoration(
                            prefixIcon: Icons.apartment_rounded,
                            label: 'Media Outlet Name',
                            borderColor: MyColorHelper.black1.withOpacity(0.50),
                            backgroundColor:
                                MyColorHelper.white.withOpacity(0.50),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        _edit.value
                            ? MyButtonHelper.simpleButton(
                                buttonText: 'Update',
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    MyDialogHelper.showLoadingDialog(context);
                                    String? response =
                                        await _controller.updateProfile(
                                            _image.value,
                                            _fullName.text.trim(),
                                            _phone.text.trim(),
                                            _mediaOutletName.text.trim());
                                    Get.back();
                                    response == null
                                        ? _edit.value = false
                                        : MySnackBarsHelper.showError(response);
                                  }
                                })
                            : MyButtonHelper.simpleButton(
                                borderColor: MyColorHelper.red1,
                                buttonColor: MyColorHelper.red1,
                                buttonText: 'Change Password',
                                onTap: () => showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) =>
                                        _MyUpdatePasswordDialog(_controller)))
                      ],
                    )),
              ),
            ),
          ),
          bottomNavigationBar: ColoredBox(
            color: MyColorHelper.black1.withOpacity(0.25),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Want to delete your account? '),
                  InkWell(
                    onTap: () => Get.to(() => MyDeleteAccount()),
                    child: Text(
                      'Delete',
                      style: TextStyle(
                          color: MyColorHelper.red,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MyUpdatePasswordDialog extends StatefulWidget {
  const _MyUpdatePasswordDialog(this._controller);
  final MyMediaUniversalController _controller;

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
                                String? str = await widget._controller
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
