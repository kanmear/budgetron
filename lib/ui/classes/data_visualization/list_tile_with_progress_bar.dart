import 'package:budgetron/ui/classes/data_visualization/elements/progress_bar.dart';
import 'package:budgetron/ui/data/fonts.dart';
import 'package:flutter/material.dart';

class ListTileWithProgressBar extends StatelessWidget {
  final String name;
  final Color color;
  final double currentValue;
  final double totalValue;
  final String leftString;
  final String rightString;

  const ListTileWithProgressBar(
      {super.key,
      required this.name,
      required this.color,
      required this.currentValue,
      required this.totalValue,
      required this.leftString,
      required this.rightString});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.square_rounded, size: 18, color: color),
              const SizedBox(width: 4),
              Text(name, style: BudgetronFonts.nunitoSize14Weight400),
            ],
          ),
          Row(
            children: [
              Text(leftString, style: BudgetronFonts.nunitoSize14Weight300),
              const SizedBox(width: 8),
              const Text('•'),
              const SizedBox(width: 8),
              Text(rightString, style: BudgetronFonts.nunitoSize14Weight400),
            ],
          ),
        ],
      ),
      const SizedBox(height: 2),
      BudgetronProgressBar(currentValue: currentValue, totalValue: totalValue)
    ]);
  }
}
