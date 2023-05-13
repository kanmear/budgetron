import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:budgetron/main.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/pages/categories_page.dart';
import 'package:budgetron/models/category.dart';

class EntryDialog extends StatefulWidget {
  const EntryDialog({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _EntryDialogState();
}

class _EntryDialogState extends State<EntryDialog> {
  final valueController = TextEditingController();
  final categoryController = TextEditingController();

  @override
  void dispose() {
    valueController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    categoryController.value = categoryController.value.copyWith(
      text: appState.selectedCategory?.name ?? "Select category",
    );

    return AlertDialog(
      title: const Text("New Entry"),
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
            controller: categoryController,
            enabled: false,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Category'),
          ),
          const CategorySelectionButton()
        ],
      ),
      actions: [
        TextButton(
            onPressed: validateEntryFields(
                    valueController.text, appState.selectedCategory)
                ? () => createEntry(
                    valueController.text, appState, categoryController)
                : null,
            child: const Text("Add entry")),
        TextButton(
            onPressed: () => objectBox.clearEntries(),
            child: const Text("Clear all entries"))
      ],
    );
  }
}

bool validateEntryFields(String text, EntryCategory? selectedCategory) {
  if (text == "" || selectedCategory == null) {
    return false;
  }
  return true;
}

void createEntry(
    String value, AppState appState, TextEditingController categoryController) {
  objectBox.addEntry(Entry(value: int.parse(value), dateTime: DateTime.now()),
      appState.selectedCategory!);
  appState.clearSelectedCategory();
  categoryController.text = "";
}

class CategorySelectionButton extends StatelessWidget {
  const CategorySelectionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
              onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoriesPage()))
                  },
              child: const Text("Category selection")),
        ),
      ],
    );
  }
}
