part of 'screen.dart';

class _MyTile extends StatelessWidget {
  const _MyTile({required this.model, required this.controller});
  final MyCompanyModel model;
  final MyCompaniesController controller;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedElevation: 0.0,
      closedColor: Colors.transparent,
      closedBuilder: (context, action) => ListTile(
        dense: true,
        contentPadding: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: MyColorHelper.red1.withOpacity(0.08),
            ),
            color: MyColorHelper.red1.withOpacity(0.05),
            image: model.logoUrl != null
                ? DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(model.logoUrl!),
                  )
                : const DecorationImage(
                    image: AssetImage(
                    'assets/images/default-company-logo.png',
                  )),
          ),
        ),
        // leading: model.logoUrl != null
        //     ? Image.network(model.logoUrl!)
        //     : Image.asset('assets/images/default-company-logo.png'),
        title: Text(model.companyName ?? 'Null'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${model.email ?? 'Null'}',
                overflow: TextOverflow.ellipsis),
            Text('Description: ${model.description ?? 'Null'}',
                overflow: TextOverflow.ellipsis),
          ],
        ),
        onTap: action,
        trailing: InkWell(
          onTap: () async {
            MyDialogHelper.showLoadingDialog(context, dark: true);
            String? response = await controller.onFollowUnFollow(model);
            Get.back();
            if (response != null) {
              MySnackBarsHelper.showError(response);
            }
          },
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              color: model.followers!.contains(controller.currentUser.id!)
                  ? Colors.red.withOpacity(0.75)
                  : Colors.blue.withOpacity(0.75),
            ),
            child: Text(
              model.followers!.contains(controller.currentUser.id!)
                  ? 'Requested'
                  : 'Follow',
              style: const TextStyle(fontSize: 14, color: MyColorHelper.white),
            ),
          ),
        ),
      ),
      openBuilder: (context, action) => _MyCompanyDetail(model: model),
    );
  }
}
