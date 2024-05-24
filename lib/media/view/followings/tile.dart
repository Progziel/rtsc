part of 'screen.dart';

class _MyTile extends StatelessWidget {
  const _MyTile(this.i, this.controller);
  final int i;
  final MyFollowingsController controller;

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
            image: controller.followings[i].logoUrl != null
                ? DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(controller.followings[i].logoUrl!),
                  )
                : const DecorationImage(
                    image: AssetImage(
                    'assets/images/default-company-logo.png',
                  )),
          ),
        ),
        // leading: controller.followings[i].logoUrl != null
        //     ? Image.network(controller.followings[i].logoUrl!)
        //     : Image.asset('assets/images/default-company-logo.png'),
        title: Text(controller.followings[i].companyName ?? 'Null'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Address: ${controller.followings[i].email ?? 'Null'}',
                overflow: TextOverflow.ellipsis),
            Text(
                'Description: ${controller.followings[i].description ?? 'Null'}',
                overflow: TextOverflow.ellipsis),
          ],
        ),
        onTap: action,
        trailing: _notificationSwitch(i, controller),
      ),
      openBuilder: (context, action) => _MyFollowingDetail(i, controller),
    );
  }
}

Widget _notificationSwitch(int i, MyFollowingsController controller) {
  final value = (controller.currentUser.notifications != null &&
          controller.currentUser.notifications!
              .contains(controller.followings[i].id))
      .obs;
  return Obx(() => Switch(
      value: value.value,
      activeColor: MyColorHelper.red1,
      onChanged: (v) {
        controller.onNotificationAction(
            controller.currentUser, controller.followings[i].id);
        value.value = v;
        value.value
            ? MySnackBarsHelper.showMessage('Notifications On', dark: true)
            : MySnackBarsHelper.showMessage('Notifications Off', dark: true);
      }));
}
