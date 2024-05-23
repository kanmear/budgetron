import 'package:flutter/material.dart';

import 'package:budgetron/ui/classes/docked_popup.dart';
import 'package:budgetron/ui/classes/text_fields/small_text_field.dart';
import 'package:budgetron/models/category/category.dart';
import 'package:budgetron/models/enums/entry_category_type.dart';
import 'package:budgetron/routes/pages/category/category_selection_page.dart';
import 'package:budgetron/ui/classes/select_button.dart';
import 'package:budgetron/ui/data/fonts.dart';

class NewGroupDialog extends StatefulWidget {
  NewGroupDialog({super.key});

  final ValueNotifier<List<EntryCategory>> categoriesNotifier =
      ValueNotifier([]);

  @override
  State<NewGroupDialog> createState() => _NewGroupDialogState();
}

class _NewGroupDialogState extends State<NewGroupDialog> {
  @override
  Widget build(BuildContext context) {
    return DockedDialog(
        title: 'New Group',
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Name', style: BudgetronFonts.nunitoSize14Weight600),
          const SizedBox(height: 4),
          BudgetronSmallTextField(
              hintText: 'Enter group name',
              autoFocus: true,
              onSubmitted: () => {},
              inputType: TextInputType.text),
          const SizedBox(height: 16),
          Text('Categories', style: BudgetronFonts.nunitoSize14Weight600),
          const SizedBox(height: 4),
          BudgetronSelectButton(
              hint: 'Choose categories to group',
              onTap: () =>
                  _navigateToCategorySelection(context, _setCategories))
        ]));
  }

  void _setCategories(List<EntryCategory> groups) {
    setState(() {
      widget.categoriesNotifier.value = groups;
    });
  }

  Future<void> _navigateToCategorySelection(
      BuildContext context, Function callback) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CategorySelectionPage(
                categoryTypeNotifier: ValueNotifier(EntryCategoryType.expense),
                isMultipleSelection: true)));

    if (!mounted) return;
    if (result != null) callback.call(result);
  }
}
