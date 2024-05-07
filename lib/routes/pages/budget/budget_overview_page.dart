import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:budgetron/app_data.dart';
import 'package:budgetron/ui/data/icons.dart';
import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/ui/classes/app_bar.dart';
import 'package:budgetron/models/budget/budget.dart';
import 'package:budgetron/logic/budget/budget_service.dart';
import 'package:budgetron/routes/popups/budget/edit_budget_popup.dart';
import 'package:budgetron/ui/classes/data_visualization/list_tile_with_progress_bar.dart';

class BudgetOverviewPage extends StatelessWidget {
  const BudgetOverviewPage({super.key, required this.budget});

  final Budget budget;

  @override
  Widget build(BuildContext context) {
    final currency = Provider.of<AppData>(context).currency;

    var title = "${budget.category.target!.name} Budget";

    return Scaffold(
      appBar: BudgetronAppBar(
          leading: const ArrowBackIconButton(),
          actions: [
            EditBudgetIcon(budget: budget),
            const SizedBox(width: 8),
            const BudgetMenuIcon()
          ],
          title: title),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(children: [
            const BudgetHistoryOverview(),
            const SizedBox(height: 8),
            BudgetProgressBar(budget: budget, currency: currency),
            const SizedBox(height: 24),
            const AmountOfEntries(),
            const SizedBox(height: 24),
            const BudgetEntries()
          ])),
    );
  }
}

class BudgetHistoryOverview extends StatelessWidget {
  const BudgetHistoryOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}

class BudgetProgressBar extends StatelessWidget {
  const BudgetProgressBar(
      {super.key, required this.budget, required this.currency});

  final Budget budget;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final budgetPeriod = BudgetService.getPeriodById(budget.budgetPeriodIndex);
    final now = DateTime.now();

    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ListTileWithProgressBar(
              leading: _getLeading(budget),
              trailing: _getTrailing(budget),
              currentValue: 10,
              totalValue: 100,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_resolveLeftString(budgetPeriod, now),
                    style: BudgetronFonts.nunitoSize12Weight400),
                Text(_resolveRightString(budgetPeriod, now),
                    style: BudgetronFonts.nunitoSize12Weight400)
              ],
            )
          ],
        ));
  }

  Widget _getLeading(Budget budget) {
    return Row(children: [
      Text(budget.currentValue.toStringAsFixed(2),
          style: BudgetronFonts.nunitoSize16Weight400),
      const SizedBox(width: 2),
      Text(currency, style: BudgetronFonts.nunitoSize12Weight400),
    ]);
  }

  Widget _getTrailing(Budget budget) {
    return Row(children: [
      Text(budget.targetValue.toStringAsFixed(0),
          style: BudgetronFonts.nunitoSize16Weight400Gray),
      const SizedBox(width: 2),
      Text(currency, style: BudgetronFonts.nunitoSize12Weight400Gray),
    ]);
  }

  String _resolveLeftString(BudgetPeriod budgetPeriod, DateTime now) {
    if (budgetPeriod == BudgetPeriod.month) {
      return "${DateFormat.MMM().format(now)}, ${DateFormat.y().format(now)}";
    } else {
      // year period
      return DateFormat.y().format(now);
    }
  }

  String _resolveRightString(BudgetPeriod budgetPeriod, DateTime now) {
    if (budgetPeriod == BudgetPeriod.month) {
      return "${DateFormat.MMM().format(budget.resetDate)}, ${DateFormat.y().format(budget.resetDate)}";
    } else {
      // year period
      return DateFormat.y().format(budget.resetDate);
    }
  }
}

class AmountOfEntries extends StatelessWidget {
  const AmountOfEntries({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}

class BudgetEntries extends StatelessWidget {
  const BudgetEntries({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}

//TODO if changes are made, Overview should be reloaded with a new Budget
class EditBudgetIcon extends StatelessWidget {
  const EditBudgetIcon({super.key, required this.budget});

  final Budget budget;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => showDialog(
          context: context,
          builder: (context) => EditBudgetDialog(budget: budget)),
      icon: Icon(
        Icons.edit,
        color: Theme.of(context).colorScheme.primary,
      ),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }
}

class BudgetMenuIcon extends StatelessWidget {
  const BudgetMenuIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => {},
      icon: Icon(Icons.more_vert, color: Theme.of(context).colorScheme.primary),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }
}
