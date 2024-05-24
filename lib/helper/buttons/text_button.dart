part of buttons_helper;

Widget _textButton(String string, VoidCallback onTap, Color color, bool bold,
    double? fontSize) {
  return InkWell(
    hoverColor: Colors.transparent,
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        string,
        style: TextStyle(
          fontSize: fontSize,
          overflow: TextOverflow.ellipsis,
          fontWeight: bold ? FontWeight.bold : null,
          color: color,
        ),
      ),
    ),
  );
}
