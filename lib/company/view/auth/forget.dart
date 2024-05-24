part of 'screen.dart';

class _MyForgetPasswordForm extends StatelessWidget {
  _MyForgetPasswordForm(this.controller);
  final MyCompanyAuthController controller;
  final _loading = false.obs;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: MyColorHelper.black.withOpacity(0.80),
      title: Container(
        width: myDefaultMaxWidth / 2,
        margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
        child: const Text(
          'Forget Password',
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
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                  'Please enter your email below, we will send you a recovery link.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MyColorHelper.white.withOpacity(0.75),
                    fontSize: 16,
                  )),
              const SizedBox(height: 16.0),
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
              ..._loading.value
                  ? [
                      Center(
                          child: CircularProgressIndicator(
                        color: MyColorHelper.red1,
                      ))
                    ]
                  : [
                      MyButtonHelper.simpleButton(
                        buttonText: 'Send Link',
                        buttonColor: MyColorHelper.red,
                        borderColor: MyColorHelper.red,
                        onTap: () async {
                          if (controller.loginFormKey.currentState!
                              .validate()) {
                            _loading.value = true;
                            String response =
                                await controller.passwordRecovery();
                            MySnackBarsHelper.showMessage(response);
                            _loading.value = false;
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Back to ',
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
                      ),
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
  }
}
