part of 'screen.dart';

class _MyLoginScreen extends StatelessWidget {
  const _MyLoginScreen(this.controller);
  final MyCompanyAuthController controller;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: MyColorHelper.black.withOpacity(0.80),
      title: Container(
        width: myDefaultMaxWidth / 2,
        margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
        child: const Text(
          'Login',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: MyColorHelper.white),
        ),
      ),
      scrollable: true,
      content: Form(
        key: controller.loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: controller.emailController,
              style: TextStyle(color: MyColorHelper.white.withOpacity(0.75)),
              validator: (v) => (v == null || v.isEmpty) ? 'Required*' : null,
              decoration: MyDecorationHelper.textFieldDecoration(
                label: 'Email',
                labelColor: MyColorHelper.white,
                borderColor: MyColorHelper.white.withOpacity(0.10),
              ),
            ),
            const SizedBox(height: 24.0),
            TextFormField(
              obscureText: true,
              controller: controller.passwordController,
              style: TextStyle(color: MyColorHelper.white.withOpacity(0.75)),
              validator: (v) => (v == null || v.isEmpty) ? 'Required*' : null,
              decoration: MyDecorationHelper.textFieldDecoration(
                label: 'Password',
                labelColor: MyColorHelper.white,
                borderColor: MyColorHelper.white.withOpacity(0.10),
              ),
            ),
            const SizedBox(height: 4.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () => controller.setAuth = 2,
                  child: Text(
                    'Forgot Password?',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: MyColorHelper.white.withOpacity(0.75),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            MyButtonHelper.simpleButton(
              buttonText: 'Login',
              buttonColor: MyColorHelper.red,
              borderColor: MyColorHelper.red,
              onTap: () async {
                if (controller.loginFormKey.currentState!.validate()) {
                  MyDialogHelper.showLoadingDialog(context, dark: true);
                  String? response = await controller.loginUser(
                    MyUserModel(
                      email: controller.emailController.text.trim(),
                      password: controller.passwordController.text.trim(),
                    ),
                  );
                  Get.back();
                  (response == null)
                      ? controller.loadInitialData()
                      : MySnackBarsHelper.showError(response);
                }
              },
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have account?',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: MyColorHelper.white.withOpacity(0.75),
                  ),
                ),
                const SizedBox(width: 4.0),
                InkWell(
                  onTap: () => controller.setAuth = 0,
                  child: Text(
                    'Sign Up',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: MyColorHelper.red1.withOpacity(0.75),
                    ),
                  ),
                ),
              ],
            ),
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
    );
  }
}
