import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return AlertDialog(
      title: const Text("New Section"),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: 'Enter section name'),
        ),
        const ExpenseCheckbox()
      ]),
      actions: [
        TextButton(
            onPressed: () => objectBox.addCategory(Category(
                name: nameController.text, isExpense: appState.isChecked)),
            child: const Text("Add section")),
        TextButton(
            onPressed: () => objectBox.clearCategories(),
            child: const Text("Clear all sections"))
      ],
    );
  }
}

class ExpenseCheckbox extends StatefulWidget {
  const ExpenseCheckbox({
    super.key,
  });
  @override
  State<ExpenseCheckbox> createState() => _ExpenseCheckboxState();
}

class _ExpenseCheckboxState extends State<ExpenseCheckbox> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
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
              appState.updateCheck(isChecked);
            });
          },
        ),
      ],
    );
  }
}
