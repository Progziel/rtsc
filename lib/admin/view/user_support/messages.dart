part of 'page.dart';

class _MyMessagesScreen extends StatelessWidget {
  _MyMessagesScreen(this.chat);
  final MyUserSupportModel chat;
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(chat.subject ?? 'Null'),
          backgroundColor: MyColorHelper.red1,
          foregroundColor: MyColorHelper.white,
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: _stream(),
                builder: (bContext, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: MyColorHelper.red1,
                    ));
                  } else {
                    final List<MyMessageModel> messages = [];
                    if (!snapshot.hasError &&
                        snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data!.docs.isNotEmpty) {
                      messages.addAll(snapshot.data!.docs.map((e) =>
                          MyMessageModel.fromMap(
                              e.data() as Map<String, dynamic>)));
                    }
                    return ListView.separated(
                      reverse: true,
                      padding: EdgeInsets.all(8.0),
                      itemCount: messages.length,
                      itemBuilder: (iContext, i) => Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (messages[i].senderId == 'user_support')
                            SizedBox(width: 48, height: 48),
                          Expanded(child: _message(messages[i])),
                          if (messages[i].senderId != 'user_support')
                            SizedBox(width: 48, height: 48),
                        ],
                      ),
                      separatorBuilder: (sContext, i) => SizedBox(height: 8.0),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _messageController,
                      decoration: MyDecorationHelper.textFieldDecoration(
                          hints: 'Comment here...',
                          borderColor: MyColorHelper.black.withOpacity(0.15)),
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  IconButton(
                      onPressed: () => _onMessage(),
                      icon: Icon(
                        Icons.send,
                        color: MyColorHelper.black.withOpacity(0.50),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Stream<QuerySnapshot>? _stream() => FirebaseFirestore.instance
      .collection('user_support')
      .doc(chat.chatId)
      .collection('messages')
      .orderBy('createdAt', descending: true)
      .snapshots();

  Widget _message(MyMessageModel model) => Column(
        children: [
          Container(
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
                color: model.senderId == 'user_support'
                    ? MyColorHelper.white.withOpacity(0.85)
                    : MyColorHelper.red1.withOpacity(0.05),
                border: Border.all(color: MyColorHelper.red1.withOpacity(0.15)),
                borderRadius: BorderRadius.only(
                    topLeft: model.senderId == 'user_support'
                        ? const Radius.circular(8.0)
                        : Radius.zero,
                    topRight: model.senderId != 'user_support'
                        ? const Radius.circular(8.0)
                        : Radius.zero,
                    bottomLeft: const Radius.circular(8.0),
                    bottomRight: const Radius.circular(8.0))),
            child: ListTile(
              dense: true,
              title: Text(
                model.senderId == 'user_support' ? 'User Support' : 'User',
                textAlign: model.senderId == 'user_support'
                    ? TextAlign.right
                    : TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                textAlign: model.senderId == 'user_support'
                    ? TextAlign.right
                    : TextAlign.left,
                model.message ?? '',
              ),
            ),
          ),
        ],
      );

  void _onMessage() {
    DocumentReference chatReference =
        FirebaseFirestore.instance.collection('user_support').doc(chat.chatId);
    DocumentReference messageReference =
        chatReference.collection('messages').doc();
    chatReference.update({'lastMessage': _messageController.text.trim()});
    messageReference.set(MyMessageModel(
            messageId: messageReference.id,
            senderId: 'user_support',
            message: _messageController.text.trim())
        .toMap());

    _messageController.clear();
  }
}
