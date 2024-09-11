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
    //FIX hardcoded list tile margins sum value (32)
    //FIX hardcoded edge insets sum value (24)
    //REFACTOR calculate once in the Main
    final listTileWidth = (MediaQuery.of(context).size.width - 32 - 24).floor();

    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: listTileWidth / 2, child: leading),
          SizedBox(width: listTileWidth / 2, child: trailing)
        ],
      ),
      const SizedBox(height: 2),
      BudgetronProgressBar(currentValue: currentValue, totalValue: totalValue)
    ]);
  }
}
