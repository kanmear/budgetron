import 'package:flutter/material.dart';

import 'package:budgetron/main.dart';
import 'package:budgetron/models/category.dart';

class NewCategoryDialog extends StatefulWidget {
  const NewCategoryDialog({
    super.key,
  });

  @override
  State<NewCategoryDialog> createState() => _NewCategoryDialogState();
}

class _NewCategoryDialogState extends State<NewCategoryDialog> {
  final nameController = TextEditingController();
  final isExpense = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("New Category"),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: 'Enter category name'),
        ),
        ExpenseCheckbox(valueNotifier: isExpense)
      ]),
      actions: [
        TextButton(
            onPressed: () => objectBox.addCategory(EntryCategory(
                name: nameController.text, isExpense: isExpense.value)),
            child: const Text("Add category")),
        TextButton(
            onPressed: () => objectBox.clearCategories(),
            child: const Text("Clear all categories"))
      ],
    );
  }
}

class ExpenseCheckbox extends StatefulWidget {
  final ValueNotifier<bool> valueNotifier;

  const ExpenseCheckbox({super.key, required this.valueNotifier});
  @override
  State<ExpenseCheckbox> createState() => _ExpenseCheckboxState();
}

class _ExpenseCheckboxState extends State<ExpenseCheckbox> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.red;
      } else {
        return Colors.blue;
      }
    }

    return Row(
      children: [
        const Text("Expense?"),
        Checkbox(
          value: isChecked,
          checkColor: Colors.white,
          fillColor: MaterialStateProperty.resolveWith(getColor),
          onChanged: (bool? value) {
            setState(() {
              isChecked = value!;
              widget.valueNotifier.value = isChecked;
            });
          },
        ),
      ],
    );
  }
}
