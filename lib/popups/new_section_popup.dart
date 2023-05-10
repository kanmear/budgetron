import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:budgetron/main.dart';
import 'package:budgetron/models/entry.dart';

class NewSectionDialog extends StatefulWidget {
  const NewSectionDialog({
    super.key,
  });

  @override
  State<NewSectionDialog> createState() => _NewSectionDialogState();
}

class _NewSectionDialogState extends State<NewSectionDialog> {
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
            onPressed: () => objectBox.addSection(Section(
                name: nameController.text, isExpense: appState.isChecked)),
            child: const Text("Add section")),
        TextButton(
            onPressed: () => objectBox.clearSections(),
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
