import 'package:budgetron/db/budget_controller.dart';
import 'package:budgetron/models/budget.dart';
import 'package:budgetron/routes/popups/budget/new_budget_popup.dart';
import 'package:budgetron/ui/classes/text_button.dart';
import 'package:budgetron/ui/fonts.dart';
import 'package:flutter/material.dart';

import 'package:budgetron/ui/budgetron_ui.dart';
import 'package:budgetron/ui/classes/top_bar_with_tabs.dart';
import 'package:budgetron/ui/icons.dart';

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
          BudgetronAppBarWithTabs(
              leftIcon: const MenuIconButton(),
              rightIcon: const EditIconButton(),
              tabNotifier: tabNotifier,
              tabs: Row(
                children: [
                  BudgetronTopBarTab(
                      tabNotifier: tabNotifier,
                      onTapAction: () =>
                          {tabNotifier.value = BudgetTabs.budget},
                      padding: BudgetronUI.leftTabInAppBar(),
                      name: "Budget",
                      associatedTabValue: BudgetTabs.budget),
                  BudgetronTopBarTab(
                      tabNotifier: tabNotifier,
                      onTapAction: () =>
                          {tabNotifier.value = BudgetTabs.savings},
                      padding: BudgetronUI.rightTabInAppBar(),
                      name: "Savings",
                      associatedTabValue: BudgetTabs.savings)
                ],
              )),
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
            return ListView(children: [
              for (var budget in snapshot.data!)
                ListTile(title: Text(budget.category.target!.name))
            ]);
          } else {
            return const Center(child: Text("No budgets in database"));
          }
        },
      ),
    );
    // return Expanded(child: Center(child: Text("No budgets in database")));
  }
}

enum BudgetTabs { budget, savings }
