import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/db/groups_controller.dart';
import 'package:budgetron/ui/classes/text_buttons/small_text_button.dart';

//REFACTOR very similar to delete_budget_popup (and others)
class DeleteGroupDialog extends StatelessWidget {
  final int groupId;

  const DeleteGroupDialog({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).colorScheme.background;

    return AlertDialog(
        backgroundColor: backgroundColor,
        contentPadding: const EdgeInsets.all(16),
        content: IntrinsicHeight(
            child: SizedBox(
                width: 256,
                child: Column(children: [
                  Text('Do you really want to delete this group?',
                      textAlign: TextAlign.center,
                      style: BudgetronFonts.nunitoSize16Weight400),
                  const SizedBox(height: 16),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: BudgetronSmallTextButton(
                              text: 'Cancel',
                              backgroundColor: backgroundColor,
                              borderColor:
                                  Theme.of(context).colorScheme.primary,
                              onTap: () => {Navigator.pop(context)},
                              textStyle: BudgetronFonts.nunitoSize16Weight400),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: BudgetronSmallTextButton(
                              text: 'Delete',
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                              borderColor: Theme.of(context).colorScheme.error,
                              onTap: () => _deleteGroup(context),
                              textStyle:
                                  BudgetronFonts.nunitoSize16Weight400White),
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
