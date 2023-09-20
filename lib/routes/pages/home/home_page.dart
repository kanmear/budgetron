import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/icons.dart';
import 'package:budgetron/ui/classes/top_bar_with_title.dart';

import 'micro_overview.dart';
import 'favorite_budgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(
          children: const [
            BudgetronAppBarWithTitle(
                title: 'Home', leftIconButton: MenuIconButton()),
            SizedBox(height: 8),
            MicroOverview(),
            SizedBox(height: 32),
            FavoriteBudgets()
          ],
        ));
  }
}
