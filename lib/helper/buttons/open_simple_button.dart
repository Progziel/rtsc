part of buttons_helper;

Widget _openSimpleButton(
    double margin,
    double padding,
    double fontSize,
    String buttonText,
    Color buttonColor,
    Color borderColor,
    Color textColor,
    bool disable,
    Widget openBody) {
  return OpenContainer(
      closedColor: Colors.transparent,
      closedElevation: 0.0,
      closedBuilder: (cContext, action) => _simpleButton(
          margin,
          padding,
          fontSize,
          buttonText,
          action,
          buttonColor,
          borderColor,
          textColor,
          disable),
      openBuilder: (oContext, action) => openBody);
}
