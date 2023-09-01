import 'package:budgetron/ui/classes/top_bar_with_title.dart';
import 'package:budgetron/ui/icons.dart';
import 'package:flutter/material.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(
          children: [
            const BudgetronAppBarWithTitle(
                title: 'Statistics', leftIconButton: MenuIconButton())
          ],
        ));
  }
}
