import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:budgetron/app_data.dart';
import 'package:budgetron/models/budget.dart';
import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/models/category.dart';
import 'package:budgetron/db/budget_controller.dart';
import 'package:budgetron/logic/budget/budget_service.dart';
import 'package:budgetron/logic/category/category_service.dart';
import 'package:budgetron/ui/classes/data_visualization/elements/progress_bar.dart';

class FavoriteBudgets extends StatelessWidget {
  const FavoriteBudgets({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Budget>>(
      stream: _getBudgets(),
      builder: (context, snapshot) {
        if (snapshot.data?.isNotEmpty ?? false) {
          return FavoriteBudgetsListView(budgets: snapshot.data!);
        } else {
          return Center(
              child: Text('No favorite budgets',
                  style: BudgetronFonts.nunitoSize16Weight300Gray));
        }
      },
    );
  }

  _getBudgets() {
    return BudgetController.getBudgetsForMainPage();
  }
}

class FavoriteBudgetsListView extends StatelessWidget {
  final List<Budget> budgets;

  const FavoriteBudgetsListView({super.key, required this.budgets});

  @override
  Widget build(BuildContext context) {
    budgets.sort((a, b) => b.targetValue.compareTo(a.targetValue));

    return SizedBox(
      //REFACTOR hardcoded values
      height: ((45 + 8) * 5) - 8,
      child: ListView(
          padding: const EdgeInsets.only(left: 16, right: 16),
          children: [
            for (var budget in budgets) BudgetListContainer(budget: budget)
          ]),
    );
  }
}

class BudgetListContainer extends StatelessWidget {
  const BudgetListContainer({
    super.key,
    required this.budget,
  });

  final Budget budget;

  @override
  Widget build(BuildContext context) {
    _resetBudget(budget);
    EntryCategory category = budget.category.target!;
    double currentValue = budget.currentValue;
    double targetValue = budget.targetValue;

    return Column(
      children: [
        BudgetListTile(
          name: category.name,
          color: CategoryService.stringToColor(category.color),
          currentValue: currentValue,
          totalValue: targetValue,
          leftString: currentValue.toStringAsFixed(2),
          rightString: targetValue.toStringAsFixed(0),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  void _resetBudget(Budget budget) {
    if (BudgetService.resetBudget(budget)) {
      BudgetController.updateBudget(budget);
    }
  }
}

class BudgetListTile extends StatelessWidget {
  final String name;
  final Color color;
  final double currentValue;
  final double totalValue;
  final String leftString;
  final String rightString;

  const BudgetListTile(
      {super.key,
      required this.name,
      required this.color,
      required this.currentValue,
      required this.totalValue,
      required this.leftString,
      required this.rightString});

  @override
  Widget build(BuildContext context) {
    final currency = Provider.of<AppData>(context).currency;

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: Theme.of(context).colorScheme.surface),
      padding: const EdgeInsets.all(10),
      child: Column(children: [
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
                Text("$rightString $currency",
                    style: BudgetronFonts.nunitoSize14Weight400),
              ],
            ),
          ],
        ),
        const SizedBox(height: 2),
        BudgetronProgressBar(currentValue: currentValue, totalValue: totalValue)
      ]),
    );
  }
}
