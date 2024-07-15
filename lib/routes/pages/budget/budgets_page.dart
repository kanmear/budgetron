import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:budgetron/app_data.dart';
import 'package:budgetron/models/category/category.dart';
import 'package:budgetron/models/budget/budget.dart';
import 'package:budgetron/db/budget_controller.dart';
import 'package:budgetron/models/enums/currency.dart';
import 'package:budgetron/logic/budget/budget_service.dart';
import 'package:budgetron/logic/category/category_service.dart';
import 'package:budgetron/routes/popups/budget/new_budget_popup.dart';
import 'package:budgetron/routes/pages/budget/budget_overview_page.dart';
import 'package:budgetron/ui/classes/text_buttons/large_text_button.dart';
import 'package:budgetron/ui/classes/data_visualization/list_tile_with_progress_bar.dart';

class BudgetsPage extends StatelessWidget {
  const BudgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: const Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Column(children: [
          BudgetsView(),
        ]),
      ),
    );
  }
}

class BudgetsView extends StatelessWidget {
  const BudgetsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              const BudgetsListView(),
              Align(
                alignment: Alignment.bottomCenter,
                child: BudgetronLargeTextButton(
                  text: 'Add budget',
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  onTap: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => NewBudgetDialog()),
                  isActive: () => true,
                  listenables: const [],
                ),
              )
            ],
          )),
    );
  }
}

class BudgetsListView extends StatelessWidget {
  const BudgetsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: StreamBuilder<List<Budget>>(
          stream: BudgetController.getBudgets(),
          builder: (context, snapshot) {
            if (snapshot.data?.isNotEmpty ?? false) {
              final List<Budget> budgets = snapshot.data!;
              List<int> datePeriods =
                  BudgetPeriod.values.map((e) => e.periodIndex).toList();

              return ListView.separated(
                  itemCount: datePeriods.length,
                  itemBuilder: (BuildContext context, int index) {
                    var period = datePeriods[index];
                    var periodBudgets = budgets
                        .where((budget) => budget.budgetPeriodIndex == period)
                        .toList();
                    if (periodBudgets.isEmpty) return const SizedBox();

                    return Column(
                      children: [
                        BudgetListTileContainer(
                            budgets: budgets
                                .where((budget) =>
                                    budget.budgetPeriodIndex == period)
                                .toList(),
                            period: period,
                            theme: theme),
                        const SizedBox(height: 16)
                      ],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    //REFACTOR .separated is not needed
                    return const SizedBox();
                  });
            } else {
              return Center(
                  child: Text('No budgets in database',
                      style: theme.textTheme.bodyMedium!.apply(
                          color: theme.colorScheme.surfaceContainerHigh)));
            }
          }),
    );
  }
}

class BudgetListTileContainer extends StatelessWidget {
  final List<Budget> budgets;
  final int period;
  final ThemeData theme;

  const BudgetListTileContainer(
      {super.key,
      required this.budgets,
      required this.period,
      required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Text(BudgetService.getPeriodByIndex(period).name,
            style: theme.textTheme.labelSmall),
      ),
      const SizedBox(height: 8),
      Column(children: [
        for (var budget in budgets)
          Column(children: [
            BudgetListTile(budget: budget, theme: theme),
            const SizedBox(height: 8)
          ])
      ])
    ]);
  }
}

class BudgetListTile extends StatelessWidget {
  const BudgetListTile({
    super.key,
    required this.budget,
    required this.theme,
  });

  final Budget budget;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);

    _resetBudget(budget);
    EntryCategory category = budget.category.target!;
    double currentValue = budget.currentValue;
    double targetValue = budget.targetValue;

    String currency = Currency.values
        .where((e) => e.index == appData.currencyIndex)
        .first
        .code;

    return InkWell(
      onTap: () => _navigateToBudgetOverview(context, budget.id),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: theme.colorScheme.surfaceContainerLowest),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTileWithProgressBar(
              leading: _getLeading(category),
              currentValue: currentValue,
              totalValue: targetValue,
              trailing: _getTrailing(currentValue, targetValue, currency),
            ),
            const SizedBox(height: 2),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                  BudgetService.calculateRemainingDays(budget.resetDate),
                  style: theme.textTheme.labelSmall),
            ),
          ],
        ),
      ),
    );
  }

  _resetBudget(Budget budget) {
    if (BudgetService.resetBudget(budget)) {
      BudgetController.updateBudget(budget);
    }
  }

  _navigateToBudgetOverview(BuildContext context, int budgetId) =>
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BudgetOverviewPage(budgetId: budgetId)));

  Widget _getLeading(EntryCategory category) {
    return Row(
      children: [
        Icon(Icons.square_rounded,
            size: 18, color: CategoryService.stringToColor(category.color)),
        const SizedBox(width: 4),
        Text(category.name, style: theme.textTheme.bodyMedium),
      ],
    );
  }

  Widget _getTrailing(
      double currentValue, double targetValue, String currency) {
    return Row(
      children: [
        Text(currentValue.toStringAsFixed(2),
            style: theme.textTheme.labelMedium),
        const SizedBox(width: 8),
        Text('•',
            style: theme.textTheme.titleSmall!.apply(fontSizeFactor: 0.8)),
        const SizedBox(width: 8),
        Text("${targetValue.toStringAsFixed(0)} $currency",
            style: theme.textTheme.labelMedium),
      ],
    );
  }
}
