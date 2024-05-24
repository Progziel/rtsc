part of '../page.dart';

class MyTiles extends StatelessWidget {
  const MyTiles({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 12,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
                color: color,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                fontSize: size,
                overflow: TextOverflow.ellipsis,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
