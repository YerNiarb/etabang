import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VerticalDashedLine extends StatelessWidget {
  final double height;
  final Color color;
  final double thickness;

  const VerticalDashedLine({Key? key, this.height = 100, this.color = Colors.grey, this.thickness = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(thickness, height),
      painter: _VerticalDashedLinePainter(color: color, thickness: thickness),
    );
  }
}

class _VerticalDashedLinePainter extends CustomPainter {
  final Color color;
  final double thickness;

  _VerticalDashedLinePainter({this.color = Colors.grey, this.thickness = 1});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final dashWidth = 5;
    final dashSpace = 5;
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
