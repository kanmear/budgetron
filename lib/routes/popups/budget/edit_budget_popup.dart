import 'package:flutter/material.dart';

import 'package:budgetron/ui/classes/text_buttons/large_text_button.dart';
import 'package:budgetron/routes/popups/budget/delete_budget_popup.dart';
import 'package:budgetron/ui/classes/text_fields/text_field.dart';
import 'package:budgetron/logic/budget/budget_service.dart';
import 'package:budgetron/ui/classes/dropdown_button.dart';
import 'package:budgetron/logic/entry/entry_service.dart';
import 'package:budgetron/ui/classes/docked_popup.dart';
import 'package:budgetron/models/budget/budget.dart';
import 'package:budgetron/db/entry_controller.dart';
import 'package:budgetron/ui/classes/switch_with_text.dart';
import 'package:budgetron/models/category/category.dart';
import 'package:budgetron/models/entry.dart';

class EditBudgetDialog extends StatefulWidget {
  final Budget budget;
  final ValueNotifier<Object?> categoryNotifier = ValueNotifier(null);
  final ValueNotifier<BudgetPeriod> periodNotifier =
      ValueNotifier(BudgetPeriod.month);
  final ValueNotifier<bool> switchNotifier = ValueNotifier(true);
  final TextEditingController textController = TextEditingController();

  final ValueNotifier<bool> updateNotifier;

  EditBudgetDialog({
    super.key,
    required this.budget,
    required this.updateNotifier,
  });

  @override
  State<EditBudgetDialog> createState() => _EditBudgetDialogState();
}

class _EditBudgetDialogState extends State<EditBudgetDialog> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    EntryCategory category = widget.budget.category.target!;
    widget.periodNotifier.value =
        BudgetService.getPeriodByIndex(widget.budget.budgetPeriodIndex);
    widget.textController.text = widget.budget.targetValue.toStringAsFixed(0);
    widget.switchNotifier.value = widget.budget.onMainPage;

    return DockedDialog(
        title: '${category.name} Budget',
        body: Column(children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Spent sum', style: theme.textTheme.labelSmall),
            //TODO update this value when period is changed?
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(widget.budget.currentValue.toStringAsFixed(2),
                style: theme.textTheme.bodyMedium),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Period', style: theme.textTheme.labelSmall),
                    ),
                    const SizedBox(height: 4),
                    BudgetronDropdownButton(
                        items: _getPeriods(),
                        hint: 'Choose',
                        valueNotifier: widget.periodNotifier,
                        fallbackValue: 'Something is broken EC-031')
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Target', style: theme.textTheme.labelSmall),
                    ),
                    const SizedBox(height: 4),
                    CustomTextField(
                        textController: widget.textController,
                        inputType: TextInputType.number,
                        hintText: '0',
                        autoFocus: false,
                        onSubmitted: (value) => {})
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 24),
          BudgetronSwitchWithText(
              switchNotifier: widget.switchNotifier,
              text: 'Add budget tracking to the main screen'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: BudgetronLargeTextButton(
                    text: 'Delete',
                    backgroundColor: Theme.of(context).colorScheme.error,
                    onTap: () => _showDeleteBudgetDialog(),
                    isActive: () => true,
                    listenables: const []),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: BudgetronLargeTextButton(
                    text: 'Save',
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    onTap: () => _updateBudget(),
                    isActive: _isValid,
                    listenables: [
                      widget.periodNotifier,
                      widget.textController,
                      widget.switchNotifier
                    ]),
              ),
            ],
          ),
        ]));
  }

  Future<List<BudgetPeriod>> _getPeriods() async => BudgetPeriod.values;

  void _showDeleteBudgetDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            DeleteBudgetDialog(budget: widget.budget));
  }

  void _updateBudget() async {
    var period = widget.periodNotifier.value;
    var budgetPeriodIndex = period.periodIndex;

    List<DateTime> datePeriod =
        BudgetService.calculateDatePeriod(budgetPeriodIndex);
    List<Entry> entries = await EntryController.getEntries(
        period: datePeriod,
        categoryFilter: List.from([widget.budget.category.target!])).first;

    double recalculatedCurrentValue = EntryService.calculateTotalValue(entries);
    DateTime resetDate = budgetPeriodIndex == widget.budget.budgetPeriodIndex
        ? widget.budget.resetDate
        : BudgetService.calculateResetDate(budgetPeriodIndex, datePeriod.first);

    BudgetService.changeBudgetDetails(
        widget.budget.id,
        budgetPeriodIndex,
        double.parse(widget.textController.text),
        recalculatedCurrentValue,
        resetDate,
        widget.switchNotifier.value);
    _popDialog();
  }

  bool _isValid() {
    Budget budget = widget.budget;

    return widget.textController.text !=
            budget.targetValue.toStringAsFixed(0) ||
        widget.periodNotifier.value !=
            BudgetService.getPeriodByIndex(budget.budgetPeriodIndex) ||
        widget.switchNotifier.value != budget.onMainPage;
  }

  void _popDialog() {
    Navigator.pop(context);
    widget.updateNotifier.value = !widget.updateNotifier.value;
  }
}
