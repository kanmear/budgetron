import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

import 'entry.dart';

class EntriesPage extends StatelessWidget {
  const EntriesPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var entries = appState.entries;

    return Scaffold(
        body: ListView(
          children: [
            for (var entry in entries)
              Card(
                child: ListTile(
                  leading: entry.isExpense
                      ? const Icon(Icons.money_off)
                      : const Icon(Icons.money),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.value.toString()),
                      Text(entry.section)
                    ],
                  ),
                ),
              )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) => const EntryDialog()),
          child: const Icon(Icons.add),
        ));
  }
}

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
            onPressed: () => appState.addEntry(Entry(
                int.parse(valueController.text),
                appState.isChecked,
                sectionController.text)),
            child: const Text("Add entry")),
        TextButton(
            onPressed: () => appState.clearEntries(),
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
