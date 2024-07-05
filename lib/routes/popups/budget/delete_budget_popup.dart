import 'package:flutter/material.dart';

import 'package:budgetron/models/budget/budget.dart';
import 'package:budgetron/logic/budget/budget_service.dart';
import 'package:budgetron/ui/classes/text_buttons/small_text_button.dart';

class DeleteBudgetDialog extends StatelessWidget {
  final Budget budget;

  const DeleteBudgetDialog({super.key, required this.budget});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color backgroundColor = theme.colorScheme.surface;

    return AlertDialog(
      backgroundColor: backgroundColor,
      contentPadding: const EdgeInsets.all(16),
      content: IntrinsicHeight(
        child: SizedBox(
          width: 256,
          child: Column(children: [
            Text('Do you really want to delete this budget?',
                textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(
                child: BudgetronSmallTextButton(
                  text: 'Cancel',
                  backgroundColor: backgroundColor,
                  onTap: () => {Navigator.pop(context)},
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: BudgetronSmallTextButton(
                  text: 'Delete',
                  backgroundColor: Theme.of(context).colorScheme.error,
                  onTap: () => _deleteBudget(context),
                ),
              ),
            ])
          ]),
        ),
      ),
    );
  }

  _deleteBudget(BuildContext context) {
    //APPROACH is this fine? seems to work fine
    BudgetService.deleteBudget(budget);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
