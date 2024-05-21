import 'package:flutter/material.dart';

import 'package:budgetron/ui/classes/text_buttons/large_text_button.dart';
import 'package:budgetron/ui/classes/text_fields/small_text_field.dart';
import 'package:budgetron/logic/category/category_service.dart';
import 'package:budgetron/logic/budget/budget_service.dart';
import 'package:budgetron/ui/classes/dropdown_button.dart';
import 'package:budgetron/logic/entry/entry_service.dart';
import 'package:budgetron/ui/classes/docked_popup.dart';
import 'package:budgetron/db/category_controller.dart';
import 'package:budgetron/models/budget/budget.dart';
import 'package:budgetron/db/entry_controller.dart';
import 'package:budgetron/ui/classes/switch.dart';
import 'package:budgetron/models/category/category.dart';
import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/models/entry.dart';

class NewBudgetDialog extends StatefulWidget {
  final ValueNotifier<EntryCategory?> categoryNotifier = ValueNotifier(null);
  final ValueNotifier<BudgetPeriod> periodNotifier =
      ValueNotifier(BudgetPeriod.month);
  final ValueNotifier<bool> switchNotifier = ValueNotifier(false);
  final TextEditingController textController = TextEditingController();

  NewBudgetDialog({super.key});

  @override
  State<NewBudgetDialog> createState() => _NewBudgetDialogState();
}

class _NewBudgetDialogState extends State<NewBudgetDialog> {
  @override
  Widget build(BuildContext context) {
    return DockedDialog(
        title: 'New Budget',
        body: Column(children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Budget category',
                style: BudgetronFonts.nunitoSize14Weight300),
          ),
          const SizedBox(height: 4),
          BudgetronDropdownButton(
              valueNotifier: widget.categoryNotifier,
              items: _getCategories(),
              leading: _getLeading,
              hint: 'Choose a category to track',
              fallbackValue: 'No more categories to track'),
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
          BudgetronLargeTextButton(
              text: 'Add budget',
              backgroundColor: Theme.of(context).colorScheme.primary,
              onTap: () => _addBudget(),
              textStyle: BudgetronFonts.nunitoSize18Weight500White,
              isActive: _isValid,
              listenables: [widget.categoryNotifier, widget.textController])
        ]));
  }

  Future<List<Object>> _getCategories() async => await Future(
      () => CategoryController.getUntrackedExpenseCategories().first);

  Future<List<BudgetPeriod>> _getPeriods() async {
    return await Future(() => BudgetPeriod.values);
  }

  Widget _getLeading(EntryCategory category) {
    return Row(children: [
      Icon(Icons.square_rounded,
          size: 18, color: CategoryService.stringToColor(category.color)),
      const SizedBox(width: 8),
    ]);
  }

  void _addBudget() async {
    EntryCategory category = widget.categoryNotifier.value!;

    var period = widget.periodNotifier.value;
    int budgetPeriodIndex = period.periodIndex;

    List<DateTime> datePeriod =
        BudgetService.calculateDatePeriod(budgetPeriodIndex);
    List<Entry> entries = await EntryController.getEntries(
        period: datePeriod, categoryFilter: List.from([category])).first;

    Budget budget = Budget(
        entriesIDs: entries.map((e) => e.id).toList(),
        targetValue: double.parse(widget.textController.text),
        budgetPeriodIndex: budgetPeriodIndex,
        currentValue: EntryService.calculateTotalValue(entries),
        onMainPage: widget.switchNotifier.value,
        resetDate: BudgetService.calculateResetDate(
            budgetPeriodIndex, datePeriod.first));

    BudgetService.createBudget(budget, category);
    _popDialog();
  }

  void _popDialog() => Navigator.pop(context);

  bool _isValid() {
    return widget.textController.text.isNotEmpty &&
        widget.categoryNotifier.value != null;
  }
}
