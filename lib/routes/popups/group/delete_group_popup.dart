import 'package:flutter/material.dart';

import 'package:budgetron/db/groups_controller.dart';
import 'package:budgetron/ui/classes/text_buttons/small_text_button.dart';

//REFACTOR very similar to delete_budget_popup (and others)
class DeleteGroupDialog extends StatelessWidget {
  final int groupId;

  const DeleteGroupDialog({super.key, required this.groupId});

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
                  Text('Do you really want to delete this group?',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 16),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                            onTap: () => _deleteGroup(context),
                            isDelete: true,
                          ),
                        )
                      ])
                ]))));
  }

  _deleteGroup(BuildContext context) {
    //APPROACH is this fine? seems to work fine
    GroupsController.deleteGroup(groupId);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
