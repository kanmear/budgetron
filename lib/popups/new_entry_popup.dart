import 'package:flutter/material.dart';

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

  EntryCategory? _selectedCategory;
  set selectedCategory(EntryCategory category) => setState(() {
        _selectedCategory = category;
      });

  @override
  void dispose() {
    valueController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    categoryController.value = categoryController.value
        .copyWith(text: _selectedCategory?.name ?? "Select category");

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
          CategorySelectionButton(
            callback: (value) => setState(() {
              _selectedCategory = value;
            }),
          )
        ],
      ),
      actions: [
        TextButton(
            onPressed:
                validateEntryFields(valueController.text, _selectedCategory)
                    ? () => createEntry(valueController.text,
                        _selectedCategory!, categoryController)
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

void createEntry(String value, EntryCategory category,
    TextEditingController categoryController) {
  int intValue = int.parse(value);
  intValue *= category.isExpense ? -1 : 1;
  objectBox.addEntry(
      Entry(value: intValue, dateTime: DateTime.now()), category);
  categoryController.text = "";
}

class CategorySelectionButton extends StatefulWidget {
  final Function callback;

  const CategorySelectionButton({super.key, required this.callback});

  @override
  State<CategorySelectionButton> createState() =>
      _CategorySelectionButtonState();
}

class _CategorySelectionButtonState extends State<CategorySelectionButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
              onPressed: () =>
                  _navigateToCategorySelection(context, widget.callback),
              child: const Text("Category selection")),
        ),
      ],
    );
  }

  Future<void> _navigateToCategorySelection(
      BuildContext context, Function callback) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CategoriesPage()));

    if (!mounted) return;
    callback.call(result);
  }
}
