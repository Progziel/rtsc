part of 'screen.dart';

class _MyForm extends StatelessWidget {
  _MyForm(this.controller);
  final MyMediaAuthController controller;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _mediaOutletName = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AlertDialog(
        backgroundColor: MyColorHelper.black.withOpacity(0.95),
        title: Container(
          width: myDefaultMaxWidth / 2,
          margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Column(
            children: [
              Text(
                controller.verifyEmail.value
                    ? 'Verification'
                    : controller.user != null
                        ? 'Loading'
                        : controller.formType.value == 0
                            ? 'Login'
                            : controller.formType.value == 1
                                ? 'Sign Up'
                                : 'Forgot Password',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: MyColorHelper.white),
              ),
              if (controller.formType.value == 2) ...[
                SizedBox(height: 8.0),
                Text(
                    'Please enter your email below, we will send you a recovery link.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: MyColorHelper.white.withOpacity(0.75),
                      fontSize: 16,
                    ))
              ]
            ],
          ),
        ),
        scrollable: true,
        content: (controller.user != null && controller.isLoading.value)
            ? _loading()
            : _form(),
      ),
    );
  }

  Widget _form() => Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!controller.verifyEmail.value) ...[
              if (controller.formType.value == 1) ...[
                _fullNameWidget(),
                const SizedBox(height: 16.0),
                _phoneWidget(),
                const SizedBox(height: 16.0),
              ],
              _emailWidget(),
              if (controller.formType.value == 1) ...[
                const SizedBox(height: 16.0),
                _mediaOutletNameWidget(),
              ],
              if (controller.formType.value != 2) ...[
                const SizedBox(height: 16.0),
                _passwordWidget(),
              ],
              if (controller.formType.value == 0)
                InkWell(
                  onTap: () => controller.formType.value = 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Forgot Password?',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: MyColorHelper.red1.withOpacity(0.75),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16.0),
              if (controller.formType.value == 1) ...[
                _confirmPasswordWidget(),
                const SizedBox(height: 16.0),
              ],
            ],
            controller.isLoading.value
                ? _loading()
                : controller.error.value != null
                    ? Text(
                        controller.error.value!,
                        maxLines: controller.verifyEmail.value ? 5 : 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: controller.verifyEmail.value
                                ? MyColorHelper.white
                                : MyColorHelper.red1),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _registerButton(),
                          const SizedBox(height: 16.0),
                          _account(),
                          const SizedBox(height: 16.0),
                        ],
                      ),
            if (controller.verifyEmail.value) ...[
              const SizedBox(height: 16.0),
              _cancelVerification(),
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
      );

  Widget _loading() => Center(
        child: Padding(
          padding: EdgeInsets.all(controller.isLoading.value ? 8.0 : 8.0),
          child: const CircularProgressIndicator(
            color: MyColorHelper.red1,
          ),
        ),
      );

  Widget _fullNameWidget() => TextFormField(
        controller: _fullName,
        onChanged: (v) => controller.error.value = null,
        style: TextStyle(color: MyColorHelper.white.withOpacity(0.75)),
        validator: (v) => (v == null || v.isEmpty) ? 'Required*' : null,
        decoration: MyDecorationHelper.textFieldDecoration(
          label: 'Full Name',
          labelColor: MyColorHelper.white,
          borderColor: MyColorHelper.white.withOpacity(0.10),
        ),
      );

  Widget _phoneWidget() => TextFormField(
        controller: _phone,
        onChanged: (v) => controller.error.value = null,
        style: TextStyle(color: MyColorHelper.white.withOpacity(0.75)),
        keyboardType: TextInputType.phone,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^[0-9+]+$'))
        ],
        decoration: MyDecorationHelper.textFieldDecoration(
          label: 'Phone',
          labelColor: MyColorHelper.white,
          borderColor: MyColorHelper.white.withOpacity(0.10),
        ),
      );

  Widget _emailWidget() => TextFormField(
        controller: _email,
        onChanged: (v) => controller.error.value = null,
        style: TextStyle(color: MyColorHelper.white.withOpacity(0.75)),
        validator: (v) => (v == null || v.isEmpty) ? 'Required*' : null,
        decoration: MyDecorationHelper.textFieldDecoration(
          label: 'Email',
          labelColor: MyColorHelper.white,
          borderColor: MyColorHelper.white.withOpacity(0.10),
        ),
      );

  Widget _mediaOutletNameWidget() => TextFormField(
        controller: _mediaOutletName,
        onChanged: (v) => controller.error.value = null,
        style: TextStyle(color: MyColorHelper.white.withOpacity(0.75)),
        validator: (v) => (v == null || v.isEmpty) ? 'Required*' : null,
        decoration: MyDecorationHelper.textFieldDecoration(
          label: 'Media Outlet Name',
          labelColor: MyColorHelper.white,
          borderColor: MyColorHelper.white.withOpacity(0.10),
        ),
      );

  Widget _passwordWidget() => TextFormField(
        obscureText: true,
        controller: _password,
        onChanged: (v) => controller.error.value = null,
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
        controller: _confirmPassword,
        onChanged: (v) => controller.error.value = null,
        style: TextStyle(color: MyColorHelper.white.withOpacity(0.75)),
        validator: (v) => (v == null || v.isEmpty) ? 'Required*' : null,
        decoration: MyDecorationHelper.textFieldDecoration(
          label: 'Confirm Password',
          labelColor: MyColorHelper.white,
          borderColor: MyColorHelper.white.withOpacity(0.10),
        ),
      );

  Widget _registerButton() => MyButtonHelper.simpleButton(
        buttonText: controller.formType.value == 0
            ? 'Login'
            : controller.formType.value == 1
                ? 'Register'
                : 'Recover',
        buttonColor: MyColorHelper.red,
        borderColor: MyColorHelper.red,
        onTap: () async {
          if (controller.formType.value == 0 ||
              _password.text.trim() == _confirmPassword.text.trim() ||
              controller.formType.value == 2) {
            if (_formKey.currentState!.validate()) {
              if (controller.formType.value == 0) {
                controller.loginUser(
                  MyUserModel(
                    email: _email.text.trim(),
                    password: _password.text.trim(),
                  ),
                );
              } else if (controller.formType.value == 1) {
                controller.registerUser(
                  MyUserModel(
                    fullName: _fullName.text.trim(),
                    userType: MyUserType.mediaMember,
                    phone: _phone.text.trim(),
                    email: _email.text.trim(),
                    mediaOutletName: _mediaOutletName.text.trim(),
                    password: _password.text.trim(),
                  ),
                );
              } else {
                controller.passwordRecovery(_email.text.trim());
              }
            }
          } else {
            MySnackBarsHelper.showError('Password not matched');
          }
        },
      );

  Widget _cancelVerification() => MyButtonHelper.simpleButton(
        buttonText: 'Ok',
        buttonColor: MyColorHelper.red,
        borderColor: MyColorHelper.red,
        onTap: () async {
          await FirebaseAuth.instance.signOut();
          controller.formType.value = 0;
          controller.user = null;
          controller.error.value = null;
          controller.verifyEmail.value = false;
        },
      );

  Widget _account() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            controller.formType.value == 0
                ? 'Don\'t have an account?'
                : controller.formType.value == 1
                    ? 'Already have account?'
                    : 'Back to ',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: MyColorHelper.white.withOpacity(0.75),
            ),
          ),
          const SizedBox(width: 4.0),
          InkWell(
            onTap: () => controller.formType.value =
                controller.formType.value == 0 ? 1 : 0,
            child: Text(
              controller.formType.value == 0 ? 'Register' : 'Login',
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
}
