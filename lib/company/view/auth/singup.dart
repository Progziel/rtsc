part of 'screen.dart';

class _MySingUpScreen extends StatelessWidget {
  const _MySingUpScreen(this.controller, {this.userLoggedIn = false});
  final bool userLoggedIn;
  final MyCompanyAuthController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return AlertDialog(
          backgroundColor:
              MyColorHelper.black.withOpacity(userLoggedIn ? 0.95 : 0.80),
          title: Container(
            width:
                context.isLandscape ? myDefaultMaxWidth : myDefaultMaxWidth / 2,
            margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Text(
              getTitle(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: MyColorHelper.white),
            ),
          ),
          scrollable: true,
          content: SizedBox(
            width:
                context.isLandscape ? myDefaultMaxWidth : myDefaultMaxWidth / 2,
            child: controller.loading
                ? Column(
                    children: [
                      Center(
                        child: CircularProgressIndicator(
                          color: MyColorHelper.white.withOpacity(0.90),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  )
                : controller.error != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            controller.error!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: MyColorHelper.white.withOpacity(0.90),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          _registerButton(context),
                        ],
                      )
                    : Form(
                        key: controller.signUpFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ...(userLoggedIn &&
                                    controller.currentUser != null &&
                                    controller.currentUser!.status == false)
                                ? [
                                    const Text(
                                      'Your account has been deactivated, '
                                      'please contact your Company',
                                      textAlign: TextAlign.center,
                                      style:
                                          TextStyle(color: MyColorHelper.white),
                                    ),
                                    const SizedBox(height: 16.0),
                                  ]
                                : (userLoggedIn &&
                                        controller.currentUser != null &&
                                        controller.currentUser!.status ==
                                            true &&
                                        controller.currentCompany != null &&
                                        controller.currentCompany!.status ==
                                            false)
                                    ? [
                                        const Text(
                                          'Your Company has been deactivated, '
                                          'please contact administration',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: MyColorHelper.white),
                                        ),
                                        const SizedBox(height: 16.0),
                                      ]
                                    : (context.isLandscape &&
                                            context.width >= myDefaultMaxWidth)
                                        ? _landscapeWidgets(context)
                                        : _portraitWidgets(context),
                            _registerButton(context),
                            const SizedBox(height: 16.0),
                            if (!userLoggedIn) ...[
                              _alreadyHaveAccount(),
                              const SizedBox(height: 16.0),
                            ],
                            const SizedBox(height: 24.0),
                            Divider(color: Colors.white.withOpacity(0.50)),
                            Text(
                              '© 2024 RTSC, INC. ALL RIGHTS RESERVED.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white.withOpacity(0.75),
                              ),
                            ),
                          ],
                        ),
                      ),
          ),
        );
      },
    );
  }

  String getTitle() {
    if (controller.loading) {
      return 'Loading Detail';
    } else if (controller.error != null &&
        controller.error!.startsWith('A verification email has been')) {
      return 'Email Verification!';
    } else if (controller.error != null) {
      return 'Error!';
    }
    if (controller.currentCompany != null) {
      controller.companyName.text =
          controller.currentCompany!.companyName ?? 'Null';
      controller.ownerName.text =
          controller.currentCompany!.ownerName ?? 'Null';
      controller.description.text =
          controller.currentCompany!.description ?? 'Null';
      // controller.mailingAddress.text =
      //     controller.currentCompany!.mailingAddress ?? 'Null';
      // controller.phone.text = controller.currentCompany!.phone ?? 'Null';
      controller.email.text = controller.currentCompany!.email ?? 'Null';
      if (controller.currentCompany!.register == null) {
        return 'Pending';
      } else if (controller.currentCompany!.register == false) {
        return 'Rejected';
      } else if (controller.currentCompany!.status == false) {
        return 'Deactivated';
      }
    }
    if (controller.currentUser != null &&
        controller.currentUser!.status == false) {
      return 'Deactivated';
    }
    return 'Sign Up';
  }

  List<Widget> _landscapeWidgets(BuildContext context) => [
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
        Row(
          children: [
            Expanded(flex: 2, child: _emailWidget()),
            if (!userLoggedIn) ...[
              const SizedBox(width: 16.0),
              Expanded(flex: 1, child: _attachment(context)),
            ]
          ],
        ),
        const SizedBox(height: 16.0),
        // Row(
        //   children: [
        //     Expanded(child: _phoneWidget()),
        //     const SizedBox(width: 16.0),
        //     Expanded(child: _emailWidget()),
        //   ],
        // ),
        // const SizedBox(height: 16.0),
        if (!userLoggedIn) ...[
          Row(
            children: [
              Expanded(child: _passwordWidget()),
              const SizedBox(width: 16.0),
              Expanded(child: _confirmPasswordWidget()),
            ],
          ),
          const SizedBox(height: 16.0),
        ]
      ];

  List<Widget> _portraitWidgets(BuildContext context) => [
        _companyNameWidget(),
        const SizedBox(height: 16.0),
        _ownerNameWidget(),
        const SizedBox(height: 16.0),
        _descriptionWidget(),
        const SizedBox(height: 16.0),
        // _mailingAddress(),
        // const SizedBox(height: 16.0),
        if (!userLoggedIn) ...[
          _attachment(context),
          const SizedBox(height: 16.0),
        ],
        // _phoneWidget(),
        // const SizedBox(height: 16.0),
        _emailWidget(),
        const SizedBox(height: 16.0),
        if (!userLoggedIn) ...[
          _passwordWidget(),
          const SizedBox(height: 16.0),
          _confirmPasswordWidget(),
          const SizedBox(height: 16.0),
        ]
      ];

  Widget _registerButton(BuildContext context) => MyButtonHelper.simpleButton(
        buttonText: controller.error != null
            ? 'Ok'
            : userLoggedIn
                ? 'Home'
                : 'Register',
        buttonColor: MyColorHelper.red,
        borderColor: MyColorHelper.red,
        onTap: () async {
          if (userLoggedIn || controller.error != null) {
            controller.onLogout();
          } else {
            if (controller.password.text.trim() ==
                controller.confirmPassword.text.trim()) {
              if (controller.signUpFormKey.currentState!.validate()) {
                MyDialogHelper.showLoadingDialog(context, dark: true);
                String? response = await controller.createCompany(
                    MyCompanyModel(
                      companyName: controller.companyName.text.trim(),
                      ownerName: controller.ownerName.text.trim(),
                      description: controller.description.text.trim(),
                      // mailingAddress: controller.mailingAddress.text.trim(),
                      // phone: controller.phone.text.trim(),
                      email: controller.email.text.trim(),
                    ),
                    controller.password.text.trim(),
                    controller.logoImage.value);
                Get.back();
                (response == null)
                    ? controller.loadInitialData()
                    : MySnackBarsHelper.showError(response);
              }
            } else {
              MySnackBarsHelper.showError('Password not matched!');
            }
          }
        },
      );

  Widget _alreadyHaveAccount() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already have account?',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: MyColorHelper.white.withOpacity(0.75),
            ),
          ),
          const SizedBox(width: 4.0),
          InkWell(
            onTap: () => controller.setAuth = 1,
            child: Text(
              'Login',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: MyColorHelper.red1.withOpacity(0.75),
              ),
            ),
          ),
        ],
      );

  Widget _companyNameWidget() => TextFormField(
        controller: controller.companyName,
        enabled: !userLoggedIn,
        style: TextStyle(color: MyColorHelper.white.withOpacity(0.75)),
        validator: (v) => (v == null || v.isEmpty) ? 'Required*' : null,
        decoration: MyDecorationHelper.textFieldDecoration(
          label: 'Company Name',
          labelColor: MyColorHelper.white,
          borderColor: MyColorHelper.white.withOpacity(0.10),
        ),
      );

  Widget _ownerNameWidget() => TextFormField(
        controller: controller.ownerName,
        enabled: !userLoggedIn,
        style: TextStyle(color: MyColorHelper.white.withOpacity(0.75)),
        validator: (v) => (v == null || v.isEmpty) ? 'Required*' : null,
        decoration: MyDecorationHelper.textFieldDecoration(
          label: 'Owner\'s Name',
          labelColor: MyColorHelper.white,
          borderColor: MyColorHelper.white.withOpacity(0.10),
        ),
      );

  Widget _descriptionWidget() => TextFormField(
        maxLines: 2,
        controller: controller.description,
        enabled: !userLoggedIn,
        style: TextStyle(color: MyColorHelper.white.withOpacity(0.75)),
        validator: (v) => (v == null || v.isEmpty) ? 'Required*' : null,
        decoration: MyDecorationHelper.textFieldDecoration(
          label: 'Description',
          labelColor: MyColorHelper.white,
          borderColor: MyColorHelper.white.withOpacity(0.10),
        ),
      );

  // Widget _mailingAddress() => TextFormField(
  //       controller: controller.mailingAddress,
  //       enabled: !userLoggedIn,
  //       style: TextStyle(color: MyColorHelper.white.withOpacity(0.75)),
  //       validator: (v) => (v == null || v.isEmpty) ? 'Required*' : null,
  //       decoration: MyDecorationHelper.textFieldDecoration(
  //         label: 'Mailing Address',
  //         labelColor: MyColorHelper.white,
  //         borderColor: MyColorHelper.white.withOpacity(0.10),
  //       ),
  //     );

  Widget _attachment(BuildContext context) => MyButtonHelper.attach(
        borderColor: Colors.white.withOpacity(0.10),
        textColor: Colors.white,
        text: controller.logoImage.value == null ? 'Logo' : 'Selected',
        onTap: () => imagePicker(context,
            onSelect: (Uint8List pickedFile) =>
                controller.logoImage.value = pickedFile),
      );

  // Widget _phoneWidget() => TextFormField(
  //       controller: controller.phone,
  //       enabled: !userLoggedIn,
  //       style: TextStyle(color: MyColorHelper.white.withOpacity(0.75)),
  //       validator: (v) => (v == null || v.isEmpty) ? 'Required*' : null,
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
        controller: controller.email,
        enabled: !userLoggedIn,
        style: TextStyle(color: MyColorHelper.white.withOpacity(0.75)),
        validator: (v) => (v == null || v.isEmpty) ? 'Required*' : null,
        decoration: MyDecorationHelper.textFieldDecoration(
          label: 'Email',
          labelColor: MyColorHelper.white,
          borderColor: MyColorHelper.white.withOpacity(0.10),
        ),
      );

  Widget _passwordWidget() => TextFormField(
        obscureText: true,
        controller: controller.password,
        enabled: !userLoggedIn,
        style: TextStyle(color: MyColorHelper.white.withOpacity(0.75)),
        validator: (v) => (v == null || v.isEmpty) ? 'Required*' : null,
        decoration: MyDecorationHelper.textFieldDecoration(
          label: 'Password',
          labelColor: MyColorHelper.white,
          borderColor: MyColorHelper.white.withOpacity(0.10),
        ),
      );

  Widget _confirmPasswordWidget() => TextFormField(
        obscureText: true,
        controller: controller.confirmPassword,
        enabled: !userLoggedIn,
        style: TextStyle(color: MyColorHelper.white.withOpacity(0.75)),
        validator: (v) => (v == null || v.isEmpty) ? 'Required*' : null,
        decoration: MyDecorationHelper.textFieldDecoration(
          label: 'Confirm Password',
          labelColor: MyColorHelper.white,
          borderColor: MyColorHelper.white.withOpacity(0.10),
        ),
      );
}
