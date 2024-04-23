import 'package:flutter/material.dart';

import 'package:budgetron/ui/classes/text_buttons/large_text_button.dart';
import 'package:budgetron/routes/popups/budget/delete_budget_popup.dart';
import 'package:budgetron/ui/classes/text_fields/small_text_field.dart';
import 'package:budgetron/logic/budget/budget_service.dart';
import 'package:budgetron/ui/classes/dropdown_button.dart';
import 'package:budgetron/logic/entry/entry_service.dart';
import 'package:budgetron/ui/classes/docked_popup.dart';
import 'package:budgetron/models/budget/budget.dart';
import 'package:budgetron/db/entry_controller.dart';
import 'package:budgetron/ui/classes/switch.dart';
import 'package:budgetron/models/category.dart';
import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/models/entry.dart';

class EditBudgetDialog extends StatefulWidget {
  final Budget budget;
  final ValueNotifier<Object?> categoryNotifier = ValueNotifier(null);
  final ValueNotifier<String> periodNotifier = ValueNotifier('');
  final ValueNotifier<bool> switchNotifier = ValueNotifier(true);
  final TextEditingController textController = TextEditingController();

  EditBudgetDialog({super.key, required this.budget});

  @override
  State<EditBudgetDialog> createState() => _EditBudgetDialogState();
}

class _EditBudgetDialogState extends State<EditBudgetDialog> {
  @override
  Widget build(BuildContext context) {
    EntryCategory category = widget.budget.category.target!;
    widget.periodNotifier.value =
        BudgetService.budgetPeriodStrings[widget.budget.budgetPeriodIndex];
    widget.textController.text = widget.budget.targetValue.toStringAsFixed(0);
    widget.switchNotifier.value = widget.budget.onMainPage;

    return DockedDialog(
        title: '${category.name} Budget',
        body: Column(children: [
          Align(
            alignment: Alignment.centerLeft,
            child:
                Text('Spent sum', style: BudgetronFonts.nunitoSize14Weight300),
            //TODO update this value when period is changed?
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(widget.budget.currentValue.toStringAsFixed(2),
                style: BudgetronFonts.nunitoSize16Weight400),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Period',
                          style: BudgetronFonts.nunitoSize14Weight300),
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
                      child: Text('Target',
                          style: BudgetronFonts.nunitoSize14Weight300),
                    ),
                    const SizedBox(height: 4),
                    BudgetronSmallTextField(
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
          Container(
            color: Theme.of(context).colorScheme.surface,
            height: 58,
            padding: const EdgeInsets.all(10),
            constraints: const BoxConstraints(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Add budget tracking to the main screen',
                    style: BudgetronFonts.nunitoSize14Weight400),
                BudgetronSwitch(switchNotifier: widget.switchNotifier)
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: BudgetronLargeTextButton(
                    text: 'Delete',
                    backgroundColor: Theme.of(context).colorScheme.error,
                    onTap: () => _showDeleteBudgetDialog(),
                    textStyle: BudgetronFonts.nunitoSize18Weight500White,
                    isActive: () => true,
                    listenables: const []),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: BudgetronLargeTextButton(
                    text: 'Save',
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    onTap: () => _updateBudget(),
                    textStyle: BudgetronFonts.nunitoSize18Weight500White,
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

  Future<List<String>> _getPeriods() async {
    return await Future(() => BudgetService.budgetPeriodStrings);
  }

  void _showDeleteBudgetDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            DeleteBudgetDialog(budget: widget.budget));
  }

  void _updateBudget() async {
    String period = widget.periodNotifier.value;
    List<DateTime> datePeriod = BudgetService.calculateDatePeriod(period);
    List<Entry> entries = await EntryController.getEntries(
        period: datePeriod,
        categoryFilter: List.from([widget.budget.category.target!])).first;

    int budgetPeriodIndex = BudgetService.budgetPeriodStrings.indexOf(period);
    double recalculatedCurrentValue = EntryService.calculateTotalValue(entries);
    DateTime resetDate = budgetPeriodIndex == widget.budget.budgetPeriodIndex
        ? widget.budget.resetDate
        : BudgetService.calculateResetDate(period, datePeriod.first);

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
            BudgetService.budgetPeriodStrings[budget.budgetPeriodIndex] ||
        widget.switchNotifier.value != budget.onMainPage;
  }

  void _popDialog() => Navigator.pop(context);
}
