import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:budgetron/main.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/pages/sections_page.dart';

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
    sectionController.value = sectionController.value.copyWith(
      text: appState.selectedSection?.name ?? "Section",
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
            controller: sectionController,
            enabled: false,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Section'),
          ),
          // const SectionDropdown(),
          const SectionSelectionButton()
          // const ExpenseCheckbox()
        ],
      ),
      actions: [
        TextButton(
            onPressed: validateEntryFields(
                    valueController.text, appState.selectedSection)
                ? () => createEntry(
                    valueController.text, appState, sectionController)
                : null,
            child: const Text("Add entry")),
        TextButton(
            onPressed: () => objectBox.clearEntries(),
            child: const Text("Clear all entries"))
      ],
    );
  }
}

bool validateEntryFields(String text, Section? selectedSection) {
  if (text == "" || selectedSection == null) {
    return false;
  }
  return true;
}

void createEntry(
    String value, AppState appState, TextEditingController sectionController) {
  objectBox.addEntry(Entry(value: int.parse(value), dateTime: DateTime.now()),
      appState.selectedSection!);
  appState.clearSelectedSection();
  sectionController.text = "";
}

class SectionSelectionButton extends StatelessWidget {
  const SectionSelectionButton({
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
                            builder: (context) => const SectionPage()))
                  },
              child: const Text("Section selection")),
        ),
      ],
    );
  }
}

class SectionDropdown extends StatefulWidget {
  const SectionDropdown({
    super.key,
  });

  @override
  State<SectionDropdown> createState() => _SectionDropdownState();
}

class _SectionDropdownState extends State<SectionDropdown> {
  List<Section> sections = <Section>[Section(name: "Food", isExpense: true)];
  // List<Section> sections = <Section>[];

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DropdownButton<Section>(
          hint: const Text("Select section"),
          // value: sections.first,
          onChanged: (value) => appState.updateSection(value!),
          items: sections.map((section) {
            return DropdownMenuItem<Section>(
              value: section,
              child: Text(section.name),
            );
          }).toList(),
        ),
        TextButton(onPressed: () => {}, child: const Icon(Icons.add))
      ],
    );
  }
}
