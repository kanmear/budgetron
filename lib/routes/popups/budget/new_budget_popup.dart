import 'package:budgetron/logic/category/category_service.dart';
import 'package:budgetron/logic/budget/budget_service.dart';
import 'package:budgetron/ui/classes/dropdown_button.dart';
import 'package:budgetron/ui/classes/docked_popup.dart';
import 'package:budgetron/db/category_controller.dart';
import 'package:budgetron/ui/classes/text_field.dart';
import 'package:budgetron/models/category.dart';
import 'package:budgetron/ui/fonts.dart';
import 'package:flutter/material.dart';

class NewBudgetDialog extends StatefulWidget {
  final ValueNotifier<Object?> categoryNotifier = ValueNotifier(null);
  final ValueNotifier<Object?> periodNotifier = ValueNotifier("Month");
  final ValueNotifier<bool> switchNotifier = ValueNotifier(true);

  NewBudgetDialog({super.key});

  @override
  State<NewBudgetDialog> createState() => _NewBudgetDialogState();
}

class _NewBudgetDialogState extends State<NewBudgetDialog> {
  @override
  Widget build(BuildContext context) {
    return DockedDialog(
        title: "New Budget",
        body: Column(children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Budget category",
                style: BudgetronFonts.nunitoSize14Weight300),
          ),
          const SizedBox(height: 4),
          BudgetronDropdownButton(
              valueNotifier: widget.categoryNotifier,
              items: _getCategories(),
              leading: _getLeading,
              hint: "Choose a category to track"),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Period",
                          style: BudgetronFonts.nunitoSize14Weight300),
                    ),
                    const SizedBox(height: 4),
                    BudgetronDropdownButton(
                        items: _getPeriods(),
                        hint: "Choose ",
                        valueNotifier: widget.periodNotifier)
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Target",
                          style: BudgetronFonts.nunitoSize14Weight300),
                    ),
                    const SizedBox(height: 4),
                    BudgetronTextField(
                        inputType: TextInputType.number,
                        hintText: "0",
                        autoFocus: true,
                        onSubmitted: () => {})
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 40),
          Container(
            color: Theme.of(context).colorScheme.surface,
            height: 58,
            padding: const EdgeInsets.all(10),
            constraints: const BoxConstraints(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Add budget tracking to the main screen",
                    style: BudgetronFonts.nunitoSize14Weight400),
                Switch(
                  onChanged: (bool value) {
                    setState(() {
                      widget.switchNotifier.value = value;
                    });
                  },
                  value: widget.switchNotifier.value,
                  activeColor: Theme.of(context).colorScheme.secondary,
                )
              ],
            ),
          )
        ]));
  }

  Future<List<Object>> _getCategories() async {
    return await Future(() => CategoryController.getCategories("", null).first);
  }

  Future<List<String>> _getPeriods() async {
    return await Future(() => BudgetService.budgetPeriodStrings);
  }

  Widget _getLeading(EntryCategory category) {
    return Row(children: [
      Icon(Icons.square_rounded,
          size: 18, color: CategoryService.stringToColor(category.color)),
      const SizedBox(width: 8),
    ]);
  }
}
