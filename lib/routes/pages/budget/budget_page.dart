import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/ui/data/icons.dart';
import 'package:budgetron/models/budget.dart';
import 'package:budgetron/models/category.dart';
import 'package:budgetron/db/budget_controller.dart';
import 'package:budgetron/logic/budget/budget_service.dart';
import 'package:budgetron/ui/classes/top_bar_with_title.dart';
import 'package:budgetron/logic/category/category_service.dart';
import 'package:budgetron/routes/popups/budget/new_budget_popup.dart';
import 'package:budgetron/routes/popups/budget/edit_budget_popup.dart';
import 'package:budgetron/ui/classes/text_buttons/large_text_button.dart';
import 'package:budgetron/ui/classes/data_visualization/list_tile_with_progress_bar.dart';

class BudgetPage extends StatelessWidget {
  final ValueNotifier<BudgetTabs> tabNotifier =
      ValueNotifier(BudgetTabs.budget);

  BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(children: [
          const BudgetronAppBarWithTitle(
            title: 'Budgeting',
            leftIconButton: MenuIconButton(),
            rightIconButton: EditIconButton(),
          ),
          const SizedBox(height: 8),
          BudgetView(tabNotifier: tabNotifier),
        ]),
      ),
    );
  }
}

class BudgetView extends StatelessWidget {
  const BudgetView({
    super.key,
    required this.tabNotifier,
  });

  final ValueNotifier<BudgetTabs> tabNotifier;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              BudgetListView(
                tabNotifier: tabNotifier,
              ),
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

class BudgetListView extends StatelessWidget {
  final ValueNotifier<BudgetTabs> tabNotifier;

  const BudgetListView({super.key, required this.tabNotifier});

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
            return const Center(child: Text("No budgets in database"));
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
          child: Text(BudgetService.budgetPeriodStrings[period],
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

    return InkWell(
      onTap: () => showDialog(
          context: context,
          builder: (context) => EditBudgetDialog(budget: budget)),
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTileWithProgressBar(
              name: category.name,
              color: CategoryService.stringToColor(category.color),
              currentValue: currentValue,
              totalValue: targetValue,
              leftString: currentValue.toStringAsFixed(2),
              rightString: targetValue.toStringAsFixed(0),
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

  void _resetBudget(Budget budget) {
    if (BudgetService.resetBudget(budget)) {
      BudgetController.updateBudget(budget);
    }
  }
}

enum BudgetTabs { budget, savings }
