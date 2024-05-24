import 'package:app/helper/buttons/buttons.dart';
import 'package:app/helper/colors.dart';
import 'package:app/helper/designs.dart';
import 'package:app/helper/responsive.dart';
// import 'package:app/helper/snackbars.dart';
// import 'package:app/media/view/auth/screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDeleteAccount extends StatelessWidget {
  MyDeleteAccount({super.key});

  final _loading = false.obs, _message = Rx<String?>(null);
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Delete account permanently'),
        foregroundColor: MyColorHelper.red1,
        titleTextStyle: TextStyle(
            color: MyColorHelper.red1,
            fontWeight: FontWeight.bold,
            fontSize: 20),
      ),
      backgroundColor: MyColorHelper.red1.withOpacity(0.75),
      body: Center(
        child: SizedBox(
          width: context.width > myDefaultMaxWidth
              ? context.width * 0.75
              : double.infinity,
          child: Obx(
            () => SingleChildScrollView(
              child: _loading.value
                  ? Center(
                      child: CircularProgressIndicator(
                      color: MyColorHelper.white,
                    ))
                  : _message.value != null
                      ? Column(
                          children: [
                            Text(
                              _message.value!,
                              style: TextStyle(
                                fontSize: 20,
                                color: MyColorHelper.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            MyButtonHelper.simpleButton(
                                buttonColor: MyColorHelper.white,
                                textColor: MyColorHelper.red1,
                                buttonText: 'Try Again',
                                onTap: () => _message.value = null)
                          ],
                        )
                      : Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'This action is irreversible and will permanently '
                                'delete all your data associated  with RTSC. '
                                'If you\'re certain, please confirm your decision'
                                ' below, by entering your email and password.',
                                style: TextStyle(
                                    fontSize: context.width > myDefaultMaxWidth
                                        ? 18
                                        : 16,
                                    color: MyColorHelper.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                                height:
                                    context.width > myDefaultMaxWidth ? 24 : 8),
                            AlertDialog(
                              scrollable: true,
                              titleTextStyle: TextStyle(fontSize: 16),
                              backgroundColor:
                                  MyColorHelper.white.withOpacity(0.95),
                              icon: Icon(Icons.delete_outline_rounded,
                                  color: MyColorHelper.red1.withOpacity(0.75),
                                  size: 50),
                              content: SizedBox(
                                width: 400,
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _email,
                                        decoration: MyDecorationHelper
                                            .textFieldDecoration(
                                                label: 'Email'),
                                        validator: (v) =>
                                            (v == null || v.isEmpty)
                                                ? 'Required*'
                                                : null,
                                      ),
                                      SizedBox(height: 16.0),
                                      TextFormField(
                                        obscureText: true,
                                        controller: _password,
                                        decoration: MyDecorationHelper
                                            .textFieldDecoration(
                                                label: 'Password'),
                                        validator: (v) =>
                                            (v == null || v.isEmpty)
                                                ? 'Required*'
                                                : null,
                                      ),
                                      SizedBox(height: 48.0),
                                      MyButtonHelper.simpleButton(
                                        borderColor: MyColorHelper.red1
                                            .withOpacity(0.75),
                                        buttonColor: MyColorHelper.red1
                                            .withOpacity(0.50),
                                        buttonText: 'Delete my account',
                                        onTap: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _openAddEngineDialog(
                                                context: context);
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
            ),
          ),
        ),
      ),
    );
  }

  void _openAddEngineDialog({required BuildContext context}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) => Container(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
            child: AlertDialog(
              scrollable: true,
              backgroundColor: Colors.transparent,
              content: Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                    left: 32.0, top: 24.0, right: 32.0, bottom: 8.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5.0,
                        spreadRadius: 5.0),
                    BoxShadow(
                        color: Colors.white,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 0.0,
                        spreadRadius: 0.0)
                  ],
                ),
                child: Column(
                  children: [
                    Text('Are you sure to delete this account permanently?'),
                    SizedBox(height: 8.0),
                    MyButtonHelper.simpleButton(
                      borderColor: MyColorHelper.red1.withOpacity(0.75),
                      buttonColor: MyColorHelper.red1.withOpacity(0.50),
                      buttonText: 'Confirm',
                      onTap: () async {
                        Get.back();
                        _loading.value = true;
                        await _deleteUserPermanently();
                        _loading.value = false;
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteUserPermanently() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _email.text.trim(), password: _password.text.trim())
          .then((userCredential) {
        userCredential.user!.delete().then((value) async =>
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userCredential.user!.uid)
                .delete());
      });
      _message.value = 'Account deleted successfully';
      await Future.delayed(500.milliseconds);
      FirebaseAuth.instance.signOut();
      Get.offAllNamed('/');
      // Get.offAll(() => MyMediaAuthScreen());
      // MySnackBarsHelper.showMessage('Account deleted successfully');
    } on FirebaseAuthException catch (e) {
      _message.value = e.code;
    } catch (e) {
      _message.value = 'Error: ${e.toString()}';
    }
  }
}
