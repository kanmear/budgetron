import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:budgetron/app_data.dart';
import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/models/category/category.dart';
import 'package:budgetron/models/budget/budget.dart';
import 'package:budgetron/db/budget_controller.dart';
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
      backgroundColor: Theme.of(context).colorScheme.background,
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
                child: BudgetronBigTextButton(
                    text: "Add budget",
                    backgroundColor: Theme.of(context).colorScheme.background,
                    onTap: () => showDialog(
                        context: context,
                        builder: (BuildContext context) => NewBudgetDialog()),
                    textStyle: BudgetronFonts.nunitoSize18Weight500),
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
    return Expanded(
      child: StreamBuilder<List<Budget>>(
        stream: BudgetController.getBudgets(),
        builder: (context, snapshot) {
          if (snapshot.data?.isNotEmpty ?? false) {
            final List<Budget> budgets = snapshot.data!;
            List<int> datePeriods = BudgetService.getDatePeriods(budgets);

            return ListView(padding: EdgeInsets.zero, children: [
              for (var period in datePeriods)
                BudgetListTileContainer(
                    budgets: budgets
                        .where((budget) => budget.budgetPeriodIndex == period)
                        .toList(),
                    period: period)
            ]);
          } else {
            return Center(
                child: Text('No budgets in database',
                    style: BudgetronFonts.nunitoSize16Weight300Gray));
          }
        },
      ),
    );
  }
}

class BudgetListTileContainer extends StatelessWidget {
  final List<Budget> budgets;
  final int period;

  const BudgetListTileContainer(
      {super.key, required this.budgets, required this.period});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(BudgetService.getPeriodByIndex(period).name,
              style: BudgetronFonts.nunitoSize14Weight400Gray),
        ),
        const SizedBox(height: 8),
        Column(
          children: [
            for (var budget in budgets)
              Column(children: [
                BudgetronListTile(budget: budget),
                const SizedBox(height: 8)
              ])
          ],
        ),
        const SizedBox(height: 24)
      ],
    );
  }
}

class BudgetronListTile extends StatelessWidget {
  const BudgetronListTile({
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
    final currency = Provider.of<AppData>(context).currency;

    return InkWell(
      onTap: () => _navigateToBudgetOverview(context, budget),
      child: Container(
        color: Theme.of(context).colorScheme.surface,
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
                  style: BudgetronFonts.nunitoSize14Weight400Gray),
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

  _navigateToBudgetOverview(BuildContext context, Budget budget) =>
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BudgetOverviewPage(budget: budget)));

  Widget _getLeading(EntryCategory category) {
    return Row(
      children: [
        Icon(Icons.square_rounded,
            size: 18, color: CategoryService.stringToColor(category.color)),
        const SizedBox(width: 4),
        Text(category.name, style: BudgetronFonts.nunitoSize14Weight400),
      ],
    );
  }

  Widget _getTrailing(
      double currentValue, double targetValue, String currency) {
    return Row(
      children: [
        Text(currentValue.toStringAsFixed(2),
            style: BudgetronFonts.nunitoSize14Weight300),
        const SizedBox(width: 8),
        const Text('•'),
        const SizedBox(width: 8),
        Text("${targetValue.toStringAsFixed(0)} $currency",
            style: BudgetronFonts.nunitoSize14Weight400),
      ],
    );
  }
}
