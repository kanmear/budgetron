import 'package:budgetron/logic/category/category_service.dart';
import 'package:budgetron/ui/classes/dropdown_button.dart';
import 'package:budgetron/ui/classes/docked_popup.dart';
import 'package:budgetron/db/category_controller.dart';
import 'package:budgetron/models/category.dart';
import 'package:budgetron/ui/classes/text_button.dart';
import 'package:budgetron/ui/fonts.dart';
import 'package:flutter/material.dart';

class NewBudgetDialog extends StatefulWidget {
  final ValueNotifier<Object?> categoryNotifier = ValueNotifier(null);

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
                style: BudgetronFonts.nunitoSize14Weight400),
          ),
          const SizedBox(height: 4),
          BudgetronDropdownButton(
              valueNotifier: widget.categoryNotifier,
              items: _getCategories(),
              leading: _getLeading,
              hint: "Choose a category to track"),
        ]));
  }

  Future<List<Object>> _getCategories() async {
    return await Future(() => CategoryController.getCategories("", null).first);
  }

  Widget _getLeading(EntryCategory category) {
    return Row(children: [
      const SizedBox(width: 8),
      Icon(Icons.square_rounded,
          size: 18, color: CategoryService.stringToColor(category.color)),
      const SizedBox(width: 8),
    ]);
  }
}
