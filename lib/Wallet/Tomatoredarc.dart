import 'package:flutter/material.dart';

class CombinedArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final tomatoRedPaint = Paint()
      ..color = const Color(0xFFFF6347) // Tomato red color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20; // Thickness

    final lightGreenPaint = Paint()
      ..color = const Color(0xFF90EE90) // Light green color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20; // Thickness

    final lightBluePaint = Paint()
      ..color = const Color(0xFFADD8E6) // Light blue color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20; // Thickness

    final lightGreyPaint = Paint()
      ..color = Colors.grey[500] ?? Colors.grey // Default to grey if Colors.grey[500] is null
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20; // Thickness

    // Define the rectangle for drawing arcs
    final rect = Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2);

    // Draw the tomato red arc (40% of the circle)
    const tomatoStartAngle = 3.14 * 0.9; // Start angle adjusted
    const tomatoSweepAngle = 3.14 * 0.7; // Sweep 40% of the circle

    canvas.drawArc(rect, tomatoStartAngle, tomatoSweepAngle, false, tomatoRedPaint);

    // Draw the light green arc (50% of the circle)
    const lightGreenStartAngle = 3.14 * 0.1; // Start angle adjusted to bottom
    const lightGreenSweepAngle = 3.14 * 0.8; // Sweep 50% of the circle

    canvas.drawArc(rect, lightGreenStartAngle, lightGreenSweepAngle, false, lightGreenPaint);

    // Draw the light blue arc (25% of the circle)
    const lightBlueStartAngle = 3.14 * 1.6; // Start angle for light blue arc
    const lightBlueSweepAngle = 3.14 * 0.25; // Sweep 25% of the circle

    canvas.drawArc(rect, lightBlueStartAngle, lightBlueSweepAngle, false, lightBluePaint);

    // Draw the light grey arc to cover remaining area
    const lightGreyStartAngle = 3.14 * 1.85; // Start angle adjusted
    const lightGreySweepAngle = 3.14 * 0.25; // Sweep 50% of the circle

    canvas.drawArc(rect, lightGreyStartAngle, lightGreySweepAngle, false, lightGreyPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
