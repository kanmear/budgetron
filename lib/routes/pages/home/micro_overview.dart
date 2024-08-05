import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:budgetron/app_data.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/db/entry_controller.dart';
import 'package:budgetron/models/enums/currency.dart';
import 'package:budgetron/logic/entry/entry_service.dart';

class MicroOverview extends StatelessWidget {
  const MicroOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    final theme = Theme.of(context);

    String currency = Currency.values
        .where((e) => e.index == appData.currencyIndex)
        .first
        .code;

    return StreamBuilder<List<Entry>>(
        stream: _getEntries(),
        builder: (context, snapshot) {
          if (snapshot.data?.isNotEmpty ?? false) {
            List<Entry> entries = snapshot.data!;

            double totalIncome = EntryService.calculateTotalValue(entries
                .where((entry) => entry.category.target!.isExpense == false)
                .toList());
            double totalExpenses = EntryService.calculateTotalValue(entries
                .where((entry) => entry.category.target!.isExpense == true)
                .toList());

            return _getOverview(totalExpenses, totalIncome, currency, theme);
          } else {
            return _getOverview(0.00, 0.00, currency, theme);
          }
        });
  }

  _getEntries() {
    DateTime now = DateTime.now();

    return EntryController.getEntries(
        period: [DateTime(now.year, now.month), now]);
  }

  _getOverview(double totalExpenses, double totalIncome, String currency,
      ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TotalValueWithIcon(
              icon: Icon(Icons.trending_up, color: theme.colorScheme.primary),
              name: 'Income',
              text: Text("${totalIncome.toStringAsFixed(2)} $currency",
                  style: theme.textTheme.headlineLarge!
                      .apply(color: theme.colorScheme.secondary))),
          const SizedBox(width: 16),
          IncomeRatioCircle(
              total: totalExpenses + totalIncome, income: totalIncome),
          const SizedBox(width: 16),
          TotalValueWithIcon(
              icon: Icon(Icons.trending_down, color: theme.colorScheme.primary),
              name: 'Expenses',
              text: Text("${totalExpenses.toStringAsFixed(2)} $currency",
                  style: theme.textTheme.headlineLarge)),
        ],
      ),
    );
  }
}

class IncomeRatioCircle extends StatelessWidget {
  final double total;
  final double income;

  const IncomeRatioCircle(
      {super.key, required this.total, required this.income});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: IncomeRatioCirclePainter(
            context: context, total: total, income: income),
        child: const SizedBox(height: 78, width: 78));
  }
}

class IncomeRatioCirclePainter extends CustomPainter {
  final BuildContext context;
  final double total;
  final double income;

  IncomeRatioCirclePainter(
      {required this.total, required this.income, required this.context});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 8;
    paint.color = Theme.of(context).colorScheme.secondary;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = 35;

    double radian = income * 2 * pi / total;

    double startAngle = _degreeToRadians(90);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        radian, false, paint);

    startAngle += radian;
    radian = (total - income) * 2 * pi / total;

    paint.style = PaintingStyle.stroke;
    paint.color = Theme.of(context).colorScheme.surfaceContainerLowest;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        radian, false, paint);

    //TODO make progress bar edges rounded
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  double _degreeToRadians(num degree) => (degree * pi) / 180.0;
}

class TotalValueWithIcon extends StatelessWidget {
  final String name;
  final Icon icon;
  final Text text;

  const TotalValueWithIcon({
    super.key,
    required this.name,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        icon,
        const SizedBox(height: 2),
        Text(name, style: theme.textTheme.titleSmall),
        const SizedBox(height: 2),
        text
      ]),
    );
  }
}
