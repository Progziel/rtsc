part of buttons_helper;

Widget _simpleButton(
    double margin,
    double padding,
    double fontSize,
    String buttonText,
    VoidCallback onTap,
    Color buttonColor,
    Color borderColor,
    Color textColor,
    bool disable) {
  return Card(
      elevation: 6.0,
      margin: EdgeInsets.all(margin),
      color:
          disable ? buttonColor.withOpacity(0.5) : buttonColor.withOpacity(0.8),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
          side: BorderSide(
            color: disable ? borderColor.withOpacity(0.5) : borderColor,
          )),
      child: InkWell(
        borderRadius: BorderRadius.circular(32),
        onTap: disable ? null : onTap,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Text(
            buttonText,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize,
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ));
}
