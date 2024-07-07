import 'package:budgetron/models/entry.dart';
import 'package:flutter/material.dart';

import 'package:budgetron/logic/entry/entry_service.dart';
import 'package:budgetron/ui/classes/text_buttons/small_text_button.dart';

class DeleteEntryDialog extends StatelessWidget {
  final Entry entry;

  const DeleteEntryDialog({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color backgroundColor = theme.colorScheme.surface;

    return AlertDialog(
      backgroundColor: backgroundColor,
      contentPadding: const EdgeInsets.all(16),
      content: IntrinsicHeight(
        child: SizedBox(
          width: 256,
          child: Column(children: [
            Text('Do you really want to delete this entry?',
                textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(
                child: BudgetronSmallTextButton(
                  text: 'Cancel',
                  onTap: () => {Navigator.pop(context)},
                  isDelete: false,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: BudgetronSmallTextButton(
                  text: 'Delete',
                  onTap: () => _deleteEntry(context),
                  isDelete: true,
                ),
              ),
            ])
          ]),
        ),
      ),
    );
  }

  _deleteEntry(BuildContext context) {
    //APPROACH is this fine? seems to work fine
    EntryService.deleteEntry(entry);
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
