part of buttons_helper;

Widget _openProfileButton(Widget openContainer) {
  return OpenContainer(
      closedColor: Colors.transparent,
      closedShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
      closedElevation: 0,
      closedBuilder: (cContext, action) => const CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage('assets/images/default-profile.png'),
          ),
      openBuilder:
          (BuildContext context, void Function({Object? returnValue}) action) =>
              MyScreensHelper.simpleScreen(
                  title: 'Profile', context: context, body: openContainer));
}
