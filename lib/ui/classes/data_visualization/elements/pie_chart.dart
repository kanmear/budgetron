import 'package:flutter/material.dart';
import 'dart:math';

class BudgetronPieChart extends StatelessWidget {
  final List<PieChartData> data;
  final Widget? child;

  const BudgetronPieChart({super.key, required this.data, this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: PieChartPainter(data: data),
        child: SizedBox(height: 200, width: 200, child: child));
  }
}

class PieChartPainter extends CustomPainter {
  final List<PieChartData> data;

  PieChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 20;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = 90;
    double total =
        data.map((e) => e.value).reduce((value, element) => value + element);

    double startAngle = _degreeToRadians(0);

    data.sort((a, b) => b.value.compareTo(a.value));

    for (PieChartData pieChartData in data) {
      double radian = pieChartData.value * 2 * pi / total;
      paint.color = (pieChartData.color);

      canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
          startAngle, radian, false, paint);
      startAngle += radian;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  double _degreeToRadians(num degree) {
    return (degree * pi) / 180.0;
  }
}

class PieChartData {
  Color color;
  double value;
  String name;

  PieChartData({required this.color, required this.value, required this.name});
}
