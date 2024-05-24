import 'package:app/essentials/contact_info.dart';
import 'package:app/helper/buttons/buttons.dart';
import 'package:app/helper/colors.dart';
import 'package:app/helper/designs.dart';
import 'package:app/helper/dialog.dart';
import 'package:app/helper/snackbars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyContactUsWebPage extends StatelessWidget {
  MyContactUsWebPage({super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _subject = TextEditingController();
  final TextEditingController _message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Contact Us'),
        foregroundColor: MyColorHelper.white,
        titleTextStyle: TextStyle(
            color: MyColorHelper.white,
            fontWeight: FontWeight.bold,
            fontSize: 20),
        backgroundColor: MyColorHelper.red1,
      ),
      body: AlertDialog(
        scrollable: true,
        content: SizedBox(
          width: 500,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 8.0),
                Text(
                  'How can we help you?',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _fullName,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Required*' : null,
                  decoration: MyDecorationHelper.textFieldDecoration(
                    label: 'Full Name',
                    borderColor: MyColorHelper.black1.withOpacity(0.50),
                    backgroundColor: MyColorHelper.white.withOpacity(0.50),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _email,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Required*' : null,
                  decoration: MyDecorationHelper.textFieldDecoration(
                    label: 'Email',
                    borderColor: MyColorHelper.black1.withOpacity(0.50),
                    backgroundColor: MyColorHelper.white.withOpacity(0.50),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _subject,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Required*' : null,
                  decoration: MyDecorationHelper.textFieldDecoration(
                    label: 'Subject',
                    borderColor: MyColorHelper.black1.withOpacity(0.50),
                    backgroundColor: MyColorHelper.white.withOpacity(0.50),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  maxLines: 5,
                  controller: _message,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Required*' : null,
                  decoration: MyDecorationHelper.textFieldDecoration(
                    label: 'Message',
                    borderColor: MyColorHelper.black1.withOpacity(0.50),
                    backgroundColor: MyColorHelper.white.withOpacity(0.50),
                  ),
                ),
                const SizedBox(height: 16.0),
                MyButtonHelper.simpleButton(
                    borderColor: MyColorHelper.red1,
                    buttonColor: MyColorHelper.red1,
                    buttonText: 'Submit',
                    onTap: () => _submit(context))
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: MyContactInfo(),
    );
  }

  _submit(BuildContext context) async {
    MyDialogHelper.showLoadingDialog(context);
    try {
      DocumentReference chatReference =
          FirebaseFirestore.instance.collection('user_support').doc();
      await chatReference.set({
        'chatId': chatReference.id,
        'fullName': _fullName.text.trim(),
        'email': _email.text.trim(),
        'subject': _subject.text.trim(),
        'message': _message.text.trim(),
      });
      _fullName.clear();
      _email.clear();
      _subject.clear();
      _message.clear();
      Get.back();
      MySnackBarsHelper.showMessage(
          'Message sent successfully, we will contact you soon');
    } catch (e) {
      Get.back();
      MySnackBarsHelper.showError(e.toString());
    }
  }
}
