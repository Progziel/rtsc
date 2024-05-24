part of 'page.dart';

void showAddOrUpdateUserDialog(BuildContext context, {MyUserModel? model}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _MyAlertDialog(
          model: model,
          userType: (companyUniversalController.currentUser.userType ==
                      MyUserType.admin &&
                  companyUniversalController.userTabIndex == 0)
              ? MyUserType.user
              : MyUserType.prMember));
}

class _MyAlertDialog extends StatefulWidget {
  const _MyAlertDialog({required this.userType, this.model});
  final MyUserType userType;
  final MyUserModel? model;

  @override
  State<_MyAlertDialog> createState() => _MyAlertDialogState();
}

class _MyAlertDialogState extends State<_MyAlertDialog> {
  final _usersController = Get.find<MyUsersController>();
  final _formKey = GlobalKey<FormState>();
  final loading = false.obs;
  final error = ''.obs, status = ''.obs;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController fullName = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController deletionEmail = TextEditingController();
  final _image = Rx<Uint8List?>(null);
  List<String> statuses = ['Activate', 'Deactivate'];

  @override
  void initState() {
    if (widget.model != null) {
      email.text = widget.model!.email ?? 'Null';
      password.text = widget.model!.password ?? 'Null';
      fullName.text = widget.model!.fullName ?? 'Null';
      phone.text = widget.model!.phone ?? 'Null';
      status.value =
          (widget.model!.status != null && widget.model!.status == true)
              ? statuses[0]
              : statuses[1];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AlertDialog(
        scrollable: true,
        title: SizedBox(
          width: 400,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    widget.model == null
                        ? 'New ${widget.userType == MyUserType.user ? 'User' : 'PR Member'}'
                        : 'Update User',
                    style: TextStyle(fontSize: widget.model == null ? 20 : 16)),
                if (widget.model != null &&
                    widget.model!.userType != null &&
                    widget.model!.userType != MyUserType.admin)
                  InkWell(
                    onTap: _onDelete,
                    child: const Text('Delete',
                        style: TextStyle(fontSize: 14, color: Colors.red)),
                  ),
              ],
            ),
          ),
        ),
        content: Form(
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
                        : widget.model != null &&
                                widget.model!.profilePicUrl != null
                            ? DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  widget.model!.profilePicUrl!,
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
                enabled: widget.model == null,
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
                enabled: widget.model == null,
                controller: password,
                onChanged: (value) =>
                    (error.isNotEmpty) ? error.value = '' : null,
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Required*' : null,
                decoration: MyDecorationHelper.textFieldDecoration(
                  borderColor: MyColorHelper.black1.withOpacity(0.10),
                  prefixIcon: Icons.lock_rounded,
                  label: 'Password',
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
              // const SizedBox(height: 16.0),
              // MyButtonHelper.attach(
              //   borderColor: MyColorHelper.black1.withOpacity(0.10),
              //   textColor: MyColorHelper.black1,
              //   text: _image.value != null
              //       ? 'Profile picture selected'
              //       : 'Select profile picture',
              //   onTap: () => profileImagePicker(context,
              //       onSelect: (Uint8List? bytes) => _image.value = bytes),
              // ),
              if (widget.model != null) ...[
                const SizedBox(height: 16.0),
                MyDropDownHelper.simple(
                  items: statuses,
                  selectedItem: status.value,
                  onTap: (value) => status.value = value,
                  color: MyColorHelper.black1.withOpacity(0.10),
                )
              ],
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
                          hoverColor: Colors.transparent,
                          child: const Text('Cancel'),
                          onTap: () => Get.back(),
                        ),
                        InkWell(
                          onTap: _onAddOrUpdate,
                          hoverColor: Colors.transparent,
                          child: Text(widget.model == null ? 'Add' : 'Update'),
                        ),
                      ],
                    )
        ],
      ),
    );
  }

  void _onAddOrUpdate() async {
    if (_formKey.currentState!.validate()) {
      loading.value = true;
      String? str;
      if (widget.model == null) {
        str = await _usersController.addUser(
            MyUserModel(
                email: email.text.trim(),
                password: password.text.trim(),
                fullName: fullName.text.trim(),
                phone: phone.text.trim(),
                userType: widget.userType,
                status: true),
            _image.value);
      } else {
        str = await _usersController.updateUser(
            _usersController.users.indexOf(widget.model!),
            MyUserModel(
              id: widget.model!.id,
              email: email.text.trim(),
              password: password.text.trim(),
              fullName: fullName.text.trim(),
              phone: phone.text.trim(),
              userType: widget.userType,
              companyId: widget.model!.companyId,
              status: status.value == statuses[0],
              createdAt: widget.model!.createdAt,
            ),
            _image.value);
      }
      if (str != null) error.value = str;
      error.isEmpty ? Get.back() : loading.value = false;
    }
  }

  void _onDelete() {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Confirmation'),
        scrollable: true,
        content: TextFormField(
          controller: deletionEmail,
          decoration: MyDecorationHelper.textFieldDecoration(
            label: 'Email',
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          MyButtonHelper.simpleButton(
            buttonText: 'Delete',
            buttonColor: Colors.red,
            onTap: () async {
              if (widget.model!.email! == deletionEmail.text.trim()) {
                Get.back();
                loading.value = true;
                String? str = await _usersController.removeUser(widget.model!);
                if (str != null) error.value = str;
                error.isEmpty ? Get.back() : loading.value = false;
              } else {
                MySnackBarsHelper.showMessage('Email not matched');
              }
            },
          )
        ],
      ),
    );
  }
}
