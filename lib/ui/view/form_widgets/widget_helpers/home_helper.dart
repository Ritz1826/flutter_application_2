import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 8);

    final arc1 = Path();

    ///shadow
    arc1.moveTo(109, 100.5);
    arc1.arcToPoint(const Offset(53, 5), radius: const Radius.circular(29));
    canvas.drawPath(arc1, paint);

    ///left bulge shadow
    var paint3 = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 3);

    final arc3 = Path();
    arc3.moveTo(122, 102.5);
    arc3.quadraticBezierTo(-11, -1, 7, -16);
    canvas.drawPath(arc3, paint3);

    ///left bulge
    var paint2 = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    final arc2 = Path();
    arc2.moveTo(-22, 2.5);
    arc2.quadraticBezierTo(-11, 2, 7, -15);
    canvas.drawPath(arc2, paint2);

    ///right bulge
    var paint4 = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    final arc4 = Path();
    arc4.moveTo(50, -13.5);
    arc4.quadraticBezierTo(54, -3.5, 72, 2.5);

    canvas.drawPath(arc4, paint4);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint

 
    return false;
    throw UnimplementedError();
  }
}
