import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:budgetron/models/entry.dart';
import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/models/category/category.dart';
import 'package:budgetron/ui/classes/docked_popup.dart';
import 'package:budgetron/logic/entry/entry_service.dart';
import 'package:budgetron/logic/category/category_service.dart';
import 'package:budgetron/ui/classes/buttons/delete_button.dart';
import 'package:budgetron/routes/popups/entry/delete_entry_popup.dart';
import 'package:budgetron/ui/classes/text_fields/medium_text_field.dart';
import 'package:budgetron/logic/number_keyboard/number_keyboard_service.dart';

class EditEntryDialog extends StatefulWidget {
  final Entry entry;

  const EditEntryDialog({super.key, required this.entry});

  @override
  State<EditEntryDialog> createState() => _EditEntryDialogState();
}

class _EditEntryDialogState extends State<EditEntryDialog> {
  late final TextEditingController textController =
      TextEditingController(text: widget.entry.value.abs().toStringAsFixed(2));

  @override
  Widget build(BuildContext context) {
    return DockedDialog(
      title: "Edit entry",
      body: Column(children: [
        EntryDetails(entry: widget.entry),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: BudgetronMediumTextField(
                  textController: textController,
                  autoFocus: true,
                  showCursor: false,
                  readOnly: true,
                  onSubmitted: (value) => {},
                  inputType: TextInputType.number),
            ),
            const SizedBox(width: 8),
            DeleteButton(onTap: () => _deleteEntry())
          ],
        ),
      ]),
      // keyboard: BudgetronNumberKeyboard(textController: textController),
    );
  }

  _deleteEntry() => showDialog(
      context: context,
      builder: (BuildContext context) =>
          DeleteEntryDialog(entry: widget.entry));

  _submitEntryChanges(String newValue) =>
      EntryService.updateEntry(widget.entry, double.parse(newValue));

  bool _isSubmitAvailable(NumberKeyboardService keyboardService) {
    return keyboardService.isValueUpdateValid(widget.entry.value.abs());
  }
}

class EntryDetails extends StatelessWidget {
  final Entry entry;

  const EntryDetails({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    EntryCategory category = entry.category.target!;

    return Row(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.square_rounded,
                    size: 18,
                    color: CategoryService.stringToColor(category.color),
                  ),
                  const SizedBox(width: 8),
                  Text(category.name,
                      style: BudgetronFonts.nunitoSize16Weight600),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(DateFormat.yMMMd().format(entry.dateTime),
                      style: BudgetronFonts.nunitoSize14Weight400),
                  const SizedBox(width: 4),
                  Text(DateFormat.Hm().format(entry.dateTime),
                      style: BudgetronFonts.nunitoSize14Weight300Gray),
                ],
              )
            ],
          ),
        ),
        const SizedBox(width: 56)
      ],
    );
  }
}
