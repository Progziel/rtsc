part of 'auth.dart';

class _MyForm extends StatelessWidget {
  const _MyForm(this.controller);
  final MyAdminAuthController controller;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: MyColorHelper.black.withOpacity(0.75),
      title: Container(
        width: 300,
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
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: controller.email,
              style: TextStyle(color: Colors.white.withOpacity(0.75)),
              validator: (v) => (v == null || v.isEmpty) ? 'Required*' : null,
              decoration: MyDecorationHelper.textFieldDecoration(
                label: 'Username',
                labelColor: MyColorHelper.white,
                borderColor: MyColorHelper.white.withOpacity(0.10),
              ),
            ),
            const SizedBox(height: 24.0),
            TextFormField(
              obscureText: true,
              controller: controller.password,
              style: TextStyle(color: Colors.white.withOpacity(0.75)),
              validator: (v) => (v == null || v.isEmpty) ? 'Required*' : null,
              decoration: MyDecorationHelper.textFieldDecoration(
                label: 'Password',
                labelColor: MyColorHelper.white,
                borderColor: MyColorHelper.white.withOpacity(0.10),
              ),
            ),
            const SizedBox(height: 24.0),
            MyButtonHelper.simpleButton(
              buttonText: 'Login',
              buttonColor: MyColorHelper.red,
              borderColor: MyColorHelper.red,
              onTap: () async {
                if (controller.formKey.currentState!.validate()) {
                  MyDialogHelper.showLoadingDialog(context, dark: true);
                  String? response = await controller.loginUser();
                  Get.back();
                  (response == null)
                      ? Get.offAll(() => const MyAdminDashboardScreen())
                      : MySnackBarsHelper.showError(response);
                }
              },
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
