import 'package:flutter/material.dart';

import 'package:budgetron/models/budget.dart';
import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/ui/data/colors.dart';
import 'package:budgetron/logic/budget/budget_service.dart';
import 'package:budgetron/ui/classes/text_buttons/small_text_button.dart';

class DeleteBudgetDialog extends StatelessWidget {
  final Budget budget;

  const DeleteBudgetDialog({super.key, required this.budget});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).colorScheme.background;

    return AlertDialog(
      backgroundColor: backgroundColor,
      contentPadding: const EdgeInsets.all(16),
      content: IntrinsicHeight(
        child: SizedBox(
          width: 256,
          child: Column(children: [
            Text('Do you really want to delete this budget?',
                textAlign: TextAlign.center,
                style: BudgetronFonts.nunitoSize16Weight400),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(
                child: BudgetronSmallTextButton(
                    text: 'Cancel',
                    backgroundColor: backgroundColor,
                    borderColor: BudgetronColors.black,
                    onTap: () => {Navigator.pop(context)},
                    textStyle: BudgetronFonts.nunitoSize16Weight400),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: BudgetronSmallTextButton(
                    text: 'Delete',
                    backgroundColor: BudgetronColors.error,
                    borderColor: BudgetronColors.error,
                    onTap: () => _deleteBudget(context),
                    textStyle: BudgetronFonts.nunitoSize16Weight400White),
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
  }
}
