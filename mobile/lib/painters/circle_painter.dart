import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  const CirclePainter({this.color, required this.size});
  final Color? color;
  final double size;

  double get s => size;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
          ..color = color ?? const Color.fromRGBO(217, 217, 217, .15),
        c = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(c, s, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
