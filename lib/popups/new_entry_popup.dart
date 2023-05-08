import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:budgetron/main.dart';
import 'package:budgetron/models/entry.dart';

class EntryDialog extends StatefulWidget {
  const EntryDialog({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _EntryDialogState();
}

class _EntryDialogState extends State<EntryDialog> {
  final valueController = TextEditingController();
  final sectionController = TextEditingController();

  @override
  void dispose() {
    valueController.dispose();
    sectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return AlertDialog(
      title: const Text("Entry"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: valueController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Enter value'),
          ),
          TextField(
            controller: sectionController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Enter section'),
          ),
          const ExpenseCheckbox()
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => objectBox.addEntry(
                Entry(
                    value: int.parse(valueController.text),
                    dateTime: DateTime.now()),
                Section(
                    name: sectionController.text,
                    isExpense: appState.isChecked)),
            child: const Text("Add entry")),
        TextButton(
            onPressed: () => objectBox.clearEntries(),
            child: const Text("Clear all entries"))
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
