part of buttons_helper;

Widget _attach(Color borderColor, Color textColor, String text, IconData icon,
        VoidCallback onTap) =>
    InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: MyColorHelper.white.withOpacity(0.10),
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: borderColor, width: 2.0),
        ),
        child: Row(children: [
          Expanded(child: Text(text, style: TextStyle(color: textColor))),
          Icon(icon, color: borderColor)
        ]),
      ),
    );
