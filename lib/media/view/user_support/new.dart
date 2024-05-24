part of 'page.dart';

class _MyAddNewChat extends StatelessWidget {
  final MyUserModel? currentUser;
  _MyAddNewChat({this.currentUser});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _subject = TextEditingController();
  final TextEditingController _message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _fullName.text = currentUser?.fullName ?? '';
    _email.text = currentUser?.email ?? '';
    return Form(
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
          if (currentUser == null) ...[
            SizedBox(height: 16.0),
            TextFormField(
              controller: _fullName,
              validator: (v) => (v == null || v.isEmpty) ? 'Required*' : null,
              decoration: MyDecorationHelper.textFieldDecoration(
                label: 'Full Name',
                borderColor: MyColorHelper.black1.withOpacity(0.50),
                backgroundColor: MyColorHelper.white.withOpacity(0.50),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _email,
              validator: (v) => (v == null || v.isEmpty) ? 'Required*' : null,
              decoration: MyDecorationHelper.textFieldDecoration(
                label: 'Email',
                borderColor: MyColorHelper.black1.withOpacity(0.50),
                backgroundColor: MyColorHelper.white.withOpacity(0.50),
              ),
            ),
          ],
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _subject,
            validator: (v) => (v == null || v.isEmpty) ? 'Required*' : null,
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
            validator: (v) => (v == null || v.isEmpty) ? 'Required*' : null,
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
    );
  }

  _submit(BuildContext context) async {
    Get.back();
    MyDialogHelper.showLoadingDialog(context);
    try {
      DocumentReference chatReference =
          FirebaseFirestore.instance.collection('user_support').doc();
      DocumentReference messageReference =
          chatReference.collection('messages').doc();
      MyUserSupportModel chat = MyUserSupportModel(
        chatId: chatReference.id,
        senderId: currentUser?.id,
        subject: _subject.text.trim(),
        lastMessage: _message.text.trim(),
      );
      MyMessageModel message = MyMessageModel(
        messageId: messageReference.id,
        senderId: currentUser?.id,
        message: _message.text.trim(),
      );
      await chatReference.set(chat.toMap());
      await messageReference.set(message.toMap());
      Get.back();
    } catch (e) {
      Get.back();
      MySnackBarsHelper.showError(e.toString());
    }
  }
}
