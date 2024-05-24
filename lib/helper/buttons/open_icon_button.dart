part of buttons_helper;

Widget _openIconButton(
    IconData iconData,
    double iconSize,
    Color iconColor,
    Color backgroundColor,
    double margin,
    String openTitle,
    Widget openContainer) {
  return Padding(
    padding: EdgeInsets.all(margin),
    child: OpenContainer(
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        closedElevation: 0,
        closedColor: backgroundColor,
        transitionType: ContainerTransitionType.fade,
        closedBuilder: (BuildContext context, void Function() action) =>
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(iconData, size: iconSize, color: iconColor),
            ),
        openBuilder: (BuildContext context,
                void Function({Object? returnValue}) action) =>
            MyScreensHelper.simpleScreen(
                title: openTitle, context: context, body: openContainer)),
  );
}
