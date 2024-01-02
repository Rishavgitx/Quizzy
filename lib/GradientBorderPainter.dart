import 'package:flutter/material.dart';
class GradientBorderPainter extends CustomPainter {
  final List<Color> gradientColors;
  final double strokeWidth;

  GradientBorderPainter({
    required this.gradientColors,
    this.strokeWidth = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path();
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    path.addRRect(RRect.fromRectAndRadius(rect, Radius.circular(15.0)));

    paint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: gradientColors,
    ).createShader(rect);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
