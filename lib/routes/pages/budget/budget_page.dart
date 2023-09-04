import 'package:flutter/material.dart';

import 'package:budgetron/ui/fonts.dart';
import 'package:budgetron/ui/icons.dart';
import 'package:budgetron/ui/colors.dart';
import 'package:budgetron/models/budget.dart';
import 'package:budgetron/db/budget_controller.dart';
import 'package:budgetron/ui/classes/text_button.dart';
import 'package:budgetron/logic/budget/budget_service.dart';
import 'package:budgetron/ui/classes/top_bar_with_title.dart';
import 'package:budgetron/logic/category/category_service.dart';
import 'package:budgetron/routes/popups/budget/new_budget_popup.dart';
import 'package:budgetron/ui/classes/data_visualization/progress_bar.dart';

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
          const SizedBox(height: 30),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: [
                    //TODO return budget / saving listView depending on selected tab
                    BudgetListView(
                      tabNotifier: tabNotifier,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: BudgetronBigTextButton(
                          text: "Add budget",
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                          onTap: () => showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  NewBudgetDialog()),
                          textStyle: BudgetronFonts.nunitoSize18Weight500),
                    )
                  ],
                )),
          ),
        ]),
      ),
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
            return ListView(padding: EdgeInsets.zero, children: [
              for (var budget in snapshot.data!)
                BudgetronListTile(budget: budget)
            ]);
          } else {
            return const Center(child: Text("No budgets in database"));
          }
        },
      ),
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
    double currentValue = budget.currentValue;
    double targetValue = budget.targetValue;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.square_rounded,
                    size: 18,
                    color: CategoryService.stringToColor(
                      budget.category.target!.color,
                    )),
                const SizedBox(width: 4),
                Text(budget.category.target!.name,
                    style: BudgetronFonts.nunitoSize14Weight400),
              ],
            ),
            Row(
              children: [
                Text(currentValue.toStringAsFixed(2),
                    style: BudgetronFonts.nunitoSize14Weight300),
                const SizedBox(width: 8),
                const Text('•'),
                const SizedBox(width: 8),
                Text(targetValue.toString(),
                    style: BudgetronFonts.nunitoSize14Weight300),
              ],
            ),
          ],
        ),
        const SizedBox(height: 2),
        BudgetronProgressBar(
            currentValue: currentValue, targetValue: targetValue),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
              BudgetService.budgetPeriodStrings[budget.budgetPeriodIndex],
              style: BudgetronFonts.nunitoSize14Weight400),
        ),
        const SizedBox(height: 16),
        Container(
          height: 1,
          decoration: BoxDecoration(
              border: Border.all(color: BudgetronColors.gray0, width: 1)),
        ),
        const SizedBox(height: 16),
      ],
    );
    // return ListTile(title: Text(budget.category.target!.name));
  }

  void _resetBudget(Budget budget) {
    if (BudgetService.resetBudget(budget)) {
      BudgetController.updateBudget(budget);
    }
  }
}

enum BudgetTabs { budget, savings }
