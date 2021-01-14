import 'package:flutter/cupertino.dart';
import 'package:hostelfinder/utils/colorutils/colorutils.dart';

class SplashCustomPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    //canvas.drawLine(size.width * 0.7, p2, paint)
    // canvas.drawArc(
    //     Rect.fromLTRB(size.width * 0.7, 0, size.width, size.height * 0.15),
    //     0,
    //     2 * pi,
    //     false,
    //     Paint()..color = ColorUtils.YELLOW_COLOR);
    canvas.drawPath(
        Path()
          ..moveTo(size.width * 0.7, 0)
          ..lineTo(size.width, 0)
          ..lineTo(size.width, size.height * 0.18)
          ..arcToPoint(Offset(size.width * 0.7, 0),
              clockwise: true,
              largeArc: false,
              radius: Radius.circular(size.width * 0.3)),
        Paint()..color = ColorUtils.YELLOW_COLOR);
    canvas.drawPath(
        Path()
          ..moveTo(0, size.height * 0.65)
          ..lineTo(0, size.height)
          ..lineTo(size.width * 0.5, size.height)
          ..arcToPoint(Offset(0, size.height * 0.65),
              clockwise: false,
              largeArc: false,
              radius: Radius.circular(size.width * 0.6)),
        Paint()..color = ColorUtils.YELLOW_COLOR);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
