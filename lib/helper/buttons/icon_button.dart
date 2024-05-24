part of buttons_helper;

Widget _iconButton(IconData iconData, double iconSize, Color iconColor,
    Color backgroundColor, double margin, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Card(
      margin: EdgeInsets.all(margin),
      elevation: 6.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(iconData, size: iconSize, color: iconColor),
      ),
    ),
  );
}
