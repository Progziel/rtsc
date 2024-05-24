part of buttons_helper;

Widget _simpleWithIconButton(
    double margin,
    double padding,
    String iconImageUrl,
    String buttonText,
    VoidCallback onTap,
    Color buttonColor,
    Color borderColor,
    Color textColor,
    disable) {
  return InkWell(
    borderRadius: BorderRadius.circular(32),
    onTap: disable ? null : onTap,
    child: Card(
        elevation: 6.0,
        margin: EdgeInsets.all(margin),
        color: disable
            ? buttonColor.withOpacity(0.5)
            : buttonColor.withOpacity(0.8),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
            side: BorderSide(
              color: disable ? borderColor.withOpacity(0.5) : borderColor,
            )),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Row(
            children: [
              Image.asset(iconImageUrl, height: 32.0, width: 32.0),
              Expanded(
                child: Text(
                  buttonText,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 32.0, width: 32.0)
            ],
          ),
        )),
  );
}
