part of 'page.dart';

class _PostedBy extends StatelessWidget {
  const _PostedBy(this.postModel);
  final MyPostModel postModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: postModel.userProfilePicUrl == null
              ? const AssetImage('assets/images/default-profile.png')
              : null,
          foregroundImage: postModel.userProfilePicUrl != null
              ? NetworkImage(postModel.userProfilePicUrl!)
              : null,
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${postModel.userName ?? 'Null'} '
                '(${postModel.userType == 'admin' ? 'Admin'
                    '' : postModel.userType == 'user' ? 'Manager'
                    '' : postModel.userType == 'prMember' ? 'PR Member'
                    '' : 'Null'})',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 4.0),
              Text(
                'Company: ${postModel.companyName}',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: MyColorHelper.black.withOpacity(0.50),
                  fontSize: 12,
                ),
              ),
              if (postModel.userEmail != null) ...[
                const SizedBox(width: 4.0),
                Row(
                  children: [
                    Text(
                      'Email: ',
                      style: TextStyle(
                        color: MyColorHelper.black.withOpacity(0.50),
                        fontSize: 12,
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          EmailContent email = EmailContent(
                            to: [postModel.userEmail!],
                          );
                          OpenMailAppResult result =
                              await OpenMailApp.composeNewEmailInMailApp(
                                  nativePickerTitle:
                                      'Select email app to compose',
                                  emailContent: email);
                          if (!result.didOpen && !result.canOpen) {
                            MySnackBarsHelper.showError(
                                'No mail apps installed');
                          } else if (!result.didOpen &&
                              result.canOpen &&
                              context.mounted) {
                            showDialog(
                              context: context,
                              builder: (_) => MailAppPickerDialog(
                                mailApps: result.options,
                                emailContent: email,
                              ),
                            );
                          }
                        },
                        child: Text(
                          '${postModel.userEmail}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ]
            ],
          ),
        ),
        const SizedBox(height: 8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('MM-dd-yyyy').format(postModel.createdAt!),
              style: const TextStyle(fontSize: 11, color: Colors.black54),
            ),
            Text(
              DateFormat('hh:mm a').format(postModel.createdAt!),
              style: const TextStyle(fontSize: 11, color: Colors.black54),
            ),
          ],
        )
      ],
    );
  }
}
