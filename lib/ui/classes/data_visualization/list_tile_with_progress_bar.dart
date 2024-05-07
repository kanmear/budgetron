import 'package:flutter/material.dart';

import 'package:budgetron/ui/classes/data_visualization/elements/progress_bar.dart';

class ListTileWithProgressBar extends StatelessWidget {
  const ListTileWithProgressBar(
      {super.key,
      required this.currentValue,
      required this.totalValue,
      required this.leading,
      required this.trailing});

  final Widget leading;
  final double currentValue;
  final double totalValue;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [leading, trailing],
      ),
      const SizedBox(height: 2),
      BudgetronProgressBar(currentValue: currentValue, totalValue: totalValue)
    ]);
  }
}
